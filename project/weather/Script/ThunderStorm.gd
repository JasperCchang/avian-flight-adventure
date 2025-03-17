extends Node3D

@export var thunderstorm_dmg : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_area_3d_body_entered(body):
		if body.is_in_group("Player"):
			var playerStaminaNode = body.get_node("Stamina")
			var playerStamina = playerStaminaNode as Health
			print(body,' entered area with ', playerStamina.get_health())
			playerStamina.set_health(playerStamina.get_health()-thunderstorm_dmg)
			print(body,' new health: ', playerStamina.get_health())
