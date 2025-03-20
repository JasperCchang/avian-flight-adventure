extends Control

var game_system
@onready var progress_bar = $Panel/ProgressBar
@onready var h_slider = $Panel/HSlider
@onready var health = $Panel/VSlider
var distance = 0
var health_change_value

var isStart : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	game_system = get_parent()
	health.value = health.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!isStart):
		return

	if not game_system or not is_instance_valid(game_system):
		return

	distance = game_system.show_game_ui_distance()
	#health_change_value = game_system.health_system()
	progress_bar.value = distance
	h_slider.value = distance
	health.value = game_system.update_health_display()

func set_Start():
	isStart = true

func _on_tree_exited():
	GlobalSignal.Tpose_Signal.disconnect(set_Start)
	pass # Replace with function body.

func _on_tree_entered():
	GlobalSignal.Tpose_Signal.connect(set_Start)
	pass # Replace with function body.
