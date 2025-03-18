extends Node3D


@export var score = 10000
@export var foods = 2
@export var level_1_health = 3000
@export var storm = 10
@export var amount_of_tries = 1
@export var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
