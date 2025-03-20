extends Control
@onready var end_meme = $EndMeme

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
