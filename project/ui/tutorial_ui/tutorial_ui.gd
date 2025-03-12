extends Control

var tutorial_ui_db = {
	0 : { "pose_img" : "res://assets/tutorial_materials/t_pose.png" , "pose_text" : "Idle Position" , "is_pose_done" : false },
	1 : { "pose_img" : "res://assets/tutorial_materials/t_pose_left.png" , "pose_text" : "Move Right" , "is_pose_done" : false},
	2 : { "pose_img" : "res://assets/tutorial_materials/t_pose_right.png" , "pose_text" : "Move Left" , "is_pose_done" : false},
	3 : { "pose_img" : "res://assets/tutorial_materials/arms_in.png" , "pose_text" : "Descending" , "is_pose_done" : false},
	4 : { "pose_img" : "res://assets/tutorial_materials/flap_wing.png" , "pose_text" : "Ascending" , "is_pose_done" : false},
}

@onready var pose = $Panel/VBoxContainer/Pose
@onready var pose_text = $Panel/VBoxContainer/PoseText

var is_Tpose : bool = false
var is_Tpose_left : bool = false
var is_Tpose_right : bool = false
var is_arms_in : bool = false
var flap_wing : bool = false

var pose_step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pose.texture = load(tutorial_ui_db[0]["pose_img"])
	pose_text.text = tutorial_ui_db[0]["pose_text"]
	visible = true

#	for i in tutorial_ui_db:
#		pose.texture = load(tutorial_ui_db[i]["pose_img"])
#		pose_text.text = tutorial_ui_db[i]["pose_text"]
#		await get_tree().create_timer(1).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match pose_step:
		0:
			if is_Tpose and  tutorial_ui_db[0]["is_pose_done"] == false:
				next_pose(1)
		1:
			if is_Tpose_left and  tutorial_ui_db[1]["is_pose_done"] == false:
				next_pose(2)
		2:
			if is_Tpose_right and  tutorial_ui_db[2]["is_pose_done"] == false:
				next_pose(3)
		3:
			if is_arms_in and  tutorial_ui_db[3]["is_pose_done"] == false:
				next_pose(4)
		4:
			if flap_wing and  tutorial_ui_db[4]["is_pose_done"] == false:
				visible = false
				tutorial_ui_db[4]["is_pose_done"] = true

func next_pose(step : int) -> void:
	pose.texture = load(tutorial_ui_db[step]["pose_img"])
	pose_text.text = tutorial_ui_db[step]["pose_text"]
	pose_step = step
	tutorial_ui_db[step - 1]["is_pose_done"] = true

func Tpose():
	is_Tpose = true

func Tpose_Left():
	is_Tpose_left = true

func Tpose_Right():
	is_Tpose_right = true

func Arms_In():
	is_arms_in = true

func Flap_Wing():
	flap_wing = true

func _on_tree_entered():
	GlobalSignal.Tpose_Left_Signal.connect(Tpose_Left)
	GlobalSignal.Tpose_Right_Signal.connect(Tpose_Right)
	GlobalSignal.Tpose_Signal.connect(Tpose)
	GlobalSignal.Arms_In_Signal.connect(Arms_In)
	GlobalSignal.FlapWing_Signal.connect(Flap_Wing)

func _on_tree_exited():
	GlobalSignal.Tpose_Left_Signal.disconnect(Tpose_Left)
	GlobalSignal.Tpose_Right_Signal.disconnect(Tpose_Right)
	GlobalSignal.Tpose_Signal.disconnect(Tpose)
	GlobalSignal.Arms_In_Signal.disconnect(Arms_In)
	GlobalSignal.FlapWing_Signal.disconnect(Flap_Wing)
