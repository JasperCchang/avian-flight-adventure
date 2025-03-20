extends CharacterBody3D

# Can't fly below this speed
var min_flight_speed:float = 0.5
# Maximum airspeed
var max_flight_speed:float = 2
# Turn rate
var turn_speed:float = 1
# Climb/dive rate
var pitch_speed:float = 0.4
# Wings "autolevel" speed
var level_speed:float = 1.0
# Throttle change speed
var throttle_delta:float = 30
# Acceleration/deceleration
var acceleration:float = 0.2

var rotation_reset_speed: float = 0.75

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var pitch_up_time : float = 0

# Current speed
var forward_speed:float = 0
# Throttle input speed
var target_speed:float = 0
# Lets us disable certain things when grounded
var grounded = false
@onready var birdflap = $BirdModel/birdflap

@export var Stamina : Health

#var _velocity = Vector3.ZERO
var turn_input:float = 0
var max_turn_input: float = 1
var pitch_input:float = 0
var max_pitch_input: float = 1

var isPitching : bool = false
var pitchTime : float = 0

var direction : Vector3

# Store the initial rotation of the bird
var initial_rotation: Basis

var canStart : bool = false

@export var immortal : bool = false
#@export var immortal_area

func _ready():
	# Save the initial rotation of the bird
	initial_rotation = transform.basis

func _physics_process(delta):
	if canStart:
		var pitch_axis = transform.basis.x.normalized()
		var turn_axis = Vector3.UP.normalized()
		transform.basis = transform.basis.orthonormalized()
		turn_input = clamp(turn_input, -max_turn_input, max_turn_input)
		pitch_input = clamp(pitch_input, -max_pitch_input, max_pitch_input)
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
		transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
		#transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)

		birdflap.rotation.z = lerp(birdflap.rotation.z, turn_input, level_speed * delta)
		# If on the ground, don't roll the body
	#	if grounded:
	#		$Mesh/Body.rotation.y = 0
	#	else:
	#		birdflap.rotation.y = lerp($Mesh/Body.rotation.y, turn_input, level_speed * delta)
		# Accelerate/decelerate
		forward_speed  = lerp(forward_speed, target_speed, delta * acceleration)
		# Movement is always forward
		if !is_on_floor():
			velocity = -transform.basis.z * forward_speed
			velocity.y -= gravity/2 * delta
			
			Stamina.health -= 1
		else: 
			velocity = Vector3(0,0,0)
		velocity.x = direction.x * 1.5
		velocity.y = direction.y * 3
		#print('Player Velociy: ',velocity)
		# Handle landing/taking off
	#	if is_on_floor():
	#		if not grounded:
	#			rotation.x = 0
	#		velocity.y -= 1
	#		grounded = true
	#	else:
	#		grounded = false

		move_and_slide()
			# Reset only the pitch (X rotation)
			
		var current_rotation = transform.basis
		var current_euler = current_rotation.get_euler()
		var target_pitch = initial_rotation.get_euler().x  # Keep the initial pitch
		# Construct a new Basis with the target pitch and current yaw and roll
		var new_basis = Basis().rotated(Vector3.RIGHT, target_pitch) * Basis().rotated(Vector3.UP, current_euler.y) * Basis().rotated(Vector3.FORWARD, current_euler.z)
		transform.basis = current_rotation.slerp(new_basis, rotation_reset_speed * delta)
		
		if current_rotation.x == initial_rotation.x:
			direction.y = 0.0
			pass
#			resetting_rotation = false
		if isPitching:
			pitchTime += delta
			if pitchTime > 0.5:
				pitch_input = 0
				isPitching = false
		

func crashPrevent():
	pass

func turnLeft():
	direction = (transform.basis * Vector3(-1,0,0)).normalized()
	#print('Signal Recieved, turning left')
	if forward_speed > 0.5:
		turn_input += 0.75
		pitch_input = 0
func turnRight():
	direction = (transform.basis * Vector3(1,0,0)).normalized()
	if forward_speed > 0.5:
		turn_input -= 0.75
		pitch_input = 0

func resetInput():
	if !isPitching:
		turn_input = 0
		pitch_input = 0
		direction.x = 0

func pitchUp():	
	if Stamina.get_health() > 0 :
		direction = (transform.basis * Vector3(0,1,0)).normalized()
		pitch_input += 0.5
		turn_input = 0
		isPitching = true
		pitchTime = 0
	else:
		return

func pitchDown():
	direction = (transform.basis * Vector3(0,-1,0)).normalized()
	isPitching = true
	pitchTime = 0
	pitch_input -= 0.5
	turn_input = 0

func flapwing():
	print('flapping')

func levelStart():
	canStart = true
	
func levelEnd():
	canStart = false

func _on_tree_entered():
	GlobalSignal.Tpose_Left_Signal.connect(turnLeft)
	GlobalSignal.Tpose_Right_Signal.connect(turnRight)
	GlobalSignal.Tpose_Signal.connect(resetInput)
	GlobalSignal.Arms_Up_Signal.connect(pitchUp)
	GlobalSignal.FlapWing_Signal.connect(pitchUp)
	GlobalSignal.Arms_In_Signal.connect(pitchDown)
	#GlobalSignal.Idle_Pose_Signal.connect(resetInput)
	GlobalSignal.LevelStart.connect(levelStart)
	GlobalSignal.LevelEnd.connect(levelEnd)
	#GlobalSignal.NoPose.connect(resetRotation)

func _on_tree_exited():
	GlobalSignal.Tpose_Left_Signal.disconnect(turnLeft)
	GlobalSignal.Tpose_Right_Signal.disconnect(turnRight)
	GlobalSignal.Idle_Pose_Signal.disconnect(resetInput)
	GlobalSignal.Tpose_Signal.disconnect(resetInput)
	GlobalSignal.Arms_Up_Signal.disconnect(pitchUp)
	GlobalSignal.FlapWing_Signal.disconnect(pitchUp)
	GlobalSignal.Arms_In_Signal.disconnect(pitchDown)
	#GlobalSignal.NoPose.disconnect(resetRotation)
	GlobalSignal.LevelStart.disconnect(levelStart)
	GlobalSignal.LevelEnd.disconnect(levelEnd)

#func get_input(delta):
#	# Throttle input
##	if Input.is_action_pressed("throttle_up"):
##		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
##	if Input.is_action_pressed("throttle_down"):
##		var limit = 0 if grounded else min_flight_speed
##		target_speed = max(forward_speed - throttle_delta * delta, limit)
#	# Turn (roll/yaw) input
#	turn_input = 0
#	if forward_speed > 0.5:
#		turn_input -= Input.get_action_strength("roll_right")
#		turn_input += Input.get_action_strength("roll_left")
#	# Pitch (climb/dive) input
#	pitch_input = 0
#	if not grounded:
#		pitch_input -= Input.get_action_strength("pitch_down")
#	if forward_speed >= min_flight_speed:
#		pitch_input += Input.get_action_strength("pitch_up")


func _on_stamina_health_depleted():
	pass # Replace with function body.
