extends Node3D

@export var player : CharacterBody3D
@export var ui : Control
@export var starting_point : Node
@export var ending_point : Node
var player_stamina : Health
var stamina_slider : Slider


var start_to_end = 0
var distance = 0
var progress = 0

var level_1_health: int = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	start_to_end = starting_point.position.distance_to(ending_point.position)
	var stamina_node = player.get_node("Stamina")
	player_stamina = stamina_node as Health
	set_player_health(level_1_health)
	
	var StaminaUI = ui.get_node('Panel/VSlider')
	stamina_slider = StaminaUI as Slider
	set_ui_value(level_1_health)
	pass # Replace with function body.


func show_game_ui_distance():
	distance = player.position.distance_to(starting_point.position)
	progress = distance/start_to_end * 100
	return progress

func set_player_health(value):
	player_stamina.set_max_health(value)
	player_stamina.set_health(value)

func set_ui_value(value):
	stamina_slider.max_value = value
	stamina_slider.value = value

func update_health_display():
	print(player_stamina.get_health())
	return player_stamina.get_health()

