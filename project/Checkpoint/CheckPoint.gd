extends Node3D

@export var stamina_restore_amount : int = 3

var is_inside_area: bool = false
var stay_time: float = 0.0
var stay_duration: float = 2.0

var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	
	if is_inside_area:
		if player.is_on_floor():
			stay_time += delta
			print('player staying on floor')
			if stay_time >= stay_duration:
				var playerStaminaNode = player.get_node("Stamina")
				var playerStamina = playerStaminaNode as Health
				print(player,' entered area with ', playerStamina.get_health())
				playerStamina.set_health(playerStamina.get_health() + stamina_restore_amount)
				print(player,' new health: ', playerStamina.get_health())

func _on_area_3d_body_entered(body):
	is_inside_area = true
	stay_time = 0.0
	if body.is_in_group("Player"):
		player = body


func _on_area_3d_body_exited(body):
	is_inside_area = false
	pass # Replace with function body.
