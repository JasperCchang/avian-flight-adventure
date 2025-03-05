extends Control

@onready var game_system = $"../Game"
@onready var progress_bar = $Panel/ProgressBar
@onready var h_slider = $Panel/HSlider
@onready var health = $Panel/VSlider
var distance = 0
var health_change_value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance = game_system.show_game_ui_distance()
	health_change_value = game_system.health_system()
	progress_bar.value = distance
	h_slider.value = distance
	health.value += health_change_value
