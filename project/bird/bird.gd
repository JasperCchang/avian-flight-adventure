extends CharacterBody3D

var moving_distance = 0.2
const SPEED = 7
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var back_cam_1 = $"../back_cam1"

var isStart : bool = false

var input_dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(!isStart):
		return
	if !is_on_floor():
		position.x += moving_distance

func _physics_process(delta: float) -> void:
	
	if(!isStart):
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity/2 * delta
		pass

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#:= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.z = direction.x * SPEED
		velocity.y = -direction.z * SPEED
		rotate_cam(input_dir, delta)
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.x = 0
		velocity.z = 0
		reset_cam_rotation(delta)

	move_and_slide()

func set_Left():
	input_dir = Vector2(Vector2.LEFT)

func set_Right():
	input_dir = Vector2(Vector2.RIGHT)

func set_Down():
	input_dir = Vector2(0,-1)

func set_Up():
	print('revieved flapping')
	input_dir = Vector2(Vector2.UP)

func set_Start():
	input_dir = Vector2(0,0)
	isStart = true
	
#func resetRotation():
#	input_dir = Vector2(0,0)

func _on_tree_entered():
	GlobalSignal.Tpose_Left_Signal.connect(set_Left)
	GlobalSignal.Tpose_Right_Signal.connect(set_Right)
	GlobalSignal.Tpose_Signal.connect(set_Start)
#	GlobalSignal.Arms_Up_Signal.connect()
	GlobalSignal.Arms_In_Signal.connect(set_Down)
#	GlobalSignal.Idle_Pose_Signal.connect()
	GlobalSignal.FlapWing_Signal.connect(set_Up)
	#GlobalSignal.NoPose.connect(resetRotation)

func _on_tree_exited():
	GlobalSignal.Tpose_Left_Signal.disconnect(set_Left)
	GlobalSignal.Tpose_Right_Signal.disconnect(set_Right)
	GlobalSignal.Tpose_Signal.disconnect(set_Start)
#	GlobalSignal.Arms_Up_Signal.connect()
	GlobalSignal.Arms_In_Signal.disconnect(set_Down)
#	GlobalSignal.Idle_Pose_Signal.connect()
	GlobalSignal.FlapWing_Signal.disconnect(set_Up)
	#GlobalSignal.NoPose.disconnect(resetRotation)

func rotate_cam(input:Vector2, delta) -> void:
	if input.x > 0 and rotation.x < 25:
		rotation.x = lerp(rotation.x, 10 * delta, delta)
	elif input.x < 0 and rotation.x > -25:
		rotation.x = lerp(rotation.x, -10 * delta, delta)
	elif input.x == 0:
		rotation.x = lerp(rotation.x, 0.0, delta)

func reset_cam_rotation(delta) -> void:
	if rotation.x > 0:
		rotation.x = lerp(rotation.x, -10 * delta, delta)
	elif rotation.x < 0:
		rotation.x = lerp(rotation.x, 10 * delta, delta)
