extends CharacterBody3D

var moving_distance = 0.2
const SPEED = 7
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var back_cam_1 = $"../back_cam1"
@onready var cloud = preload("res://weather/weather.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_on_floor():
		position.x += moving_distance

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
		moving_distance = 0.2
		reset_cam_rotation(delta)

	move_and_slide()

func rotate_cam(input:Vector2, delta) -> void:
	if input.x > 0 and rotation.x < 25:
		rotation.x = lerp(rotation.x, 10 * delta, delta)
	elif input.x < 0 and rotation.x > -25:
		rotation.x = lerp(rotation.x, -10 * delta, delta)
		moving_distance = 0.1

func reset_cam_rotation(delta) -> void:
	if rotation.x > 0:
		rotation.x = lerp(rotation.x, -10 * delta, delta)
	elif rotation.x < 0:
		rotation.x = lerp(rotation.x, 10 * delta, delta)


func _on_area_3d_area_entered(area):
	if area == cloud:
		print("DIE")
		get_tree().reload_current_scene()
