extends Node3D
@onready var back_cam_1 = $back_cam1

@onready var birdArea: Area3D = $bird/bird_area
@onready var bird: CharacterBody3D = $bird

@onready var level_text: MeshInstance3D = $level/end/MeshInstance3D

@onready var start_point = $level/start_point
@onready var end_point = $level/end
@onready var end_point_mesh = $level/end/CollisionShape3D/MeshInstance3D

@export var clouds_to_spawn : int = 10
@export var _cloud : PackedScene
@onready var bad_weather = $bad_weather

@onready var level_1_scene
@onready var back_cam_2 = $bird/back_cam2

var is_restart = false

var start_to_end = 0
var distance = 0
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_1_scene = get_parent()
	back_cam_2.make_current()
	level_text.mesh.text = "level 1"
	start_to_end = start_point.position.distance_to(end_point.position)
	spwan_clouds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	back_cam.position.x = lerp(back_cam.position.x, bird.position.x - 10, 0.1)
	back_cam_1.position.x = bird.position.x - 25
	back_cam_1.look_at(bird.position)
	if is_restart == true:
		level_1_scene.restart()
		is_restart = false

func show_game_ui_distance():
	distance = bird.position.x
	progress = distance/start_to_end * 100
	return progress

func health_system():
	if bird.is_on_floor():
		return 5
	elif  !bird.is_on_floor():
		return -1

func spwan_clouds():
	while  clouds_to_spawn >= 0:
		clouds_to_spawn -= 1
		
		var x : float = randf_range(bird.position.x + 30, bird.position.x + 40)
		var y : float = randf_range(end_point_mesh.mesh.size.y / 2 , -end_point_mesh.mesh.size.y / 2)
		var z : float = randf_range(end_point_mesh.mesh.size.z / 2 , -end_point_mesh.mesh.size.z / 2)
		
		var spawn_pos : Vector3 = Vector3(x, y, z)
			
		var cloud := _cloud.instantiate()
		bad_weather.add_child(cloud)
		cloud.connect("area_entered", self._on_weather_area_entered)
		cloud.global_position = self.global_position + spawn_pos

#		await get_tree().create_timer(randf_range(0.5,1)).timeout

func _on_end_area_entered(area: Area3D) -> void:
	if area == birdArea:
		print("end")
		is_restart = true

func _on_level_1_area_entered(area: Area3D) -> void:
	if area == birdArea:
		print("level 1")
		level_text.mesh.text = "level 2"

func _on_level_2_area_entered(area: Area3D) -> void:
	if area == birdArea:
		print("level 2")
		level_text.mesh.text = "level 3"

func _on_level_3_area_entered(area: Area3D) -> void:
	if area == birdArea:
		print("level 3")
		level_text.mesh.text = "End"

func _on_floor_area_entered(area: Area3D):
	if area == birdArea:
		print("DIE")
		level_text.mesh.text = "Die"
		is_restart = true

func _on_weather_area_entered(area):
	if area == birdArea:
		is_restart = true
