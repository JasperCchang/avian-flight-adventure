extends Node3D

var boost_int_time : float = 0.0
var boost_duration : float = 0.25
var isBoosting : bool = false
var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if isBoosting:
		#var Camera : Camera3D = player.get_node('BirdModel/Camera3D')
		#print('Player Velociy: ',player.velocity)
		boost_int_time += delta
		player.throttle_delta = 70
		player.max_flight_speed = 4
		player.acceleration = 30
		#Camera.position_offset = Vector3(0, 2, 9)
		if boost_int_time > boost_duration:
			player.throttle_delta = 30
			player.max_flight_speed = 2
			player.acceleration = 0.2
			#Camera.position_offset = Vector3(0, 2, 7)
			isBoosting = false


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print('player boost')
		boost_int_time = 0.0
		player = body
		isBoosting = true

