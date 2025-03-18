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

############### summary value, can change if you want ##################
var level_1_health: int = 3000

@export var score = 10000
@export var foods = 2
@export var storm = 10
@export var amount_of_tries = 1

var is_time_start = false
@export var time = 0
########################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	start_to_end = starting_point.position.distance_to(ending_point.position)
	var stamina_node = player.get_node("Stamina")
	player_stamina = stamina_node as Health
	set_player_health(level_1_health)
	
	var StaminaUI = ui.get_node('Panel/VSlider')
	stamina_slider = StaminaUI as Slider
	set_ui_value(level_1_health)
	
	# start counting time
	is_time_start = true
	GlobalSignal.LevelStart.emit()
	pass # Replace with function body.

func _process(delta):
	# counting time
	if is_time_start:
		time += delta

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
	#print(player_stamina.get_health())
	return player_stamina.get_health()

func levelEnd():
	var summary_ui = load("res://ui/summary_ui/summary_ui.tscn").instantiate()
	add_child(summary_ui)
	GlobalSignal.LevelEnd.disconnect(levelEnd)

func _on_tree_entered():
	GlobalSignal.LevelEnd.connect(levelEnd)
	pass # Replace with function body.


func _on_tree_exited():
	GlobalSignal.LevelEnd.disconnect(levelEnd)
	pass # Replace with function body.
