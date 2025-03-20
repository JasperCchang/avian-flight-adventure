extends Node
var current_ui
var current_game
var new_ui
var new_game
#var current_tutorial
#var new_tutorial

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game = load("res://game_control/game.tscn").instantiate()
#	new_ui = load("res://ui/game_ui/game_ui.tscn").instantiate()
	add_child(new_game)
#	add_child(new_ui)
	current_game = new_game
#	current_ui = new_ui
#	new_tutorial = load("res://ui/tutorial_ui/Tutorial_UI.tscn").instantiate()
#	add_child(new_tutorial)
#	current_tutorial = new_tutorial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	print(current_game)
#	print(current_ui)
	if is_instance_valid(current_game) and is_instance_valid(current_ui):
#		current_game.queue_free()
#		current_ui.queue_free()
		remove_child(current_game)
#		remove_child(current_ui)
		new_game = load("res://game_control/game.tscn").instantiate()
#		new_ui = load("res://ui/game_ui/game_ui.tscn").instantiate()
		add_child(new_game)
#		add_child(new_ui)
		current_game = new_game
#		current_ui = new_ui
