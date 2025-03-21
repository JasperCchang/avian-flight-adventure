extends Control

@onready var menu = $Panel/menu
@onready var setting = $Setting_UI
@onready var level = $Level_Selection_UI

var show_menu = false
var show_setting = false
var show_level = false

# Called when the node enters the scene tree for the first time.
func _ready():
	show_menu = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show_menu:
		menu.position = menu.position.lerp(Vector2(40, menu.position.y), delta * 4)
	elif !show_menu:
		menu.position = menu.position.lerp(Vector2(-300, menu.position.y), delta * 4)

	if show_setting:
		setting.position = setting.position.lerp(Vector2(700, setting.position.y), delta * 4)
	elif !show_setting:
		setting.position = setting.position.lerp(Vector2(1200, setting.position.y), delta * 4)

	if show_level:
		level.position = level.position.lerp(Vector2(level.position.x, 0), delta * 4)
	elif !show_level:
		level.position = level.position.lerp(Vector2(level.position.x, -700), delta * 4)
	
func _on_start_button_down():
	#get_tree().change_scene_to_file("res://ui/level_selection_ui/level_selection_ui.tscn")
	show_level = true

	show_menu = false
	show_setting = false

func _on_setting_button_down():
	#get_tree().change_scene_to_file("res://ui/setting_ui/setting_ui.tscn")
	show_setting = true
	
	show_level = false
	show_menu = false

func _on_back_button_down():
	show_menu = false
	get_tree().quit()
