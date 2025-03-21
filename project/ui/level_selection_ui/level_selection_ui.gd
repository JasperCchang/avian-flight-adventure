extends Control
@onready var end_meme = $EndMeme
@onready var menu_ui = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_1_pressed():
	pass

func _on_level_2_pressed():
	pass

func _on_level_3_pressed():
	end_meme.show()
	await get_tree().create_timer(1.0).timeout

	menu_ui.show_menu = true

	menu_ui.show_setting = false
	menu_ui.show_level = false

	end_meme.hide()

