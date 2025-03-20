extends Node3D
@onready var animation_player = $Control/AnimationPlayer

@export var image : Texture2D
@onready var texture_rect = $Control/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/TextureRect

@export var title : String
@onready var label = $Control/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Label

@export var content : String
@onready var label_2 = $Control/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = image
	label.text = title
	label_2.text = content

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group('Player'):
		animation_player.startAnim()



func _on_area_3d_body_exited(body):
	if body.is_in_group('Player'):
		animation_player.endAnim()

