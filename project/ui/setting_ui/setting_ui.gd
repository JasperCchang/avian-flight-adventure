extends Control

@onready var menu_ui = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_down():
	#get_tree().change_scene_to_file("res://ui/menu_ui/menu_ui.tscn")W
	menu_ui.show_menu = true

	menu_ui.show_setting = false
	menu_ui.show_level = false
