extends Node
class_name PoseMatching

var PoseLib_instance: PoseLib
var Pose = preload("res://Pose/Pose.gd")
var label_scene: PackedScene = preload('res://Scenes/PoseLabelScene.tscn')
var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Creating PoseLib Instance")
	PoseLib_instance = PoseLib.new()
	PoseLib_instance.populatePoseLib()
	
	var label_instance = label_scene.instantiate()
	label = label_instance.get_node("Label")
	label.position = Vector2(900,370)
	add_child(label_instance)

func AngularDifference(a1: float, a2: Pose.PoseAngle):
	var abs_diff = abs(a1-a2.angle)
	return abs_diff

func GetAngle(landmark_coords: Dictionary, js: Pose.PoseLandmark,je: Pose.PoseLandmark):
	#print("js: ", js , "je: ", je)
	var sp = landmark_coords[js]
	var ep = landmark_coords[je]
	#print("sp: ",sp,"ep: ",ep)
	var angle = rad_to_deg(atan2(ep.y - sp.y, ep.x - sp.x))
	#angle = (angle + 360) % 360
	
	##print(angle)
	return angle

func IsAngleMatched(landmark_coords: Dictionary, pose_angle: Pose.PoseAngle):
	var skeletonAngle = GetAngle(landmark_coords, pose_angle.start_joint, pose_angle.end_joint)
#	if(pose_angle.start_joint == 13):
#		print("Pose Angle: ", pose_angle.start_joint, " & ", "Pose Angle: ", pose_angle.end_joint, " has an angle of: ", skeletonAngle)
	var angle_diff = AngularDifference(skeletonAngle, pose_angle)
#	if(pose_angle.start_joint == 13):
#		print("Pose Angle: ", pose_angle.start_joint, " & ", "Pose Angle: ", pose_angle.end_joint, " has an angle diff of: ", angle_diff)
	var angle_matched: bool
	if(angle_diff < pose_angle.threshold && angle_diff > -pose_angle.threshold):
		angle_matched = true
	else:
		angle_matched = false
	return angle_matched

func IsMatched(landmark_coords: Dictionary, pose: Pose):
	var pose_matched = true
	for angle in pose.angles:
#		if(angle.start_joint == 14):
#			print("Start Joint: ", angle.start_joint, ", End Joint: ", angle.end_joint, ", Angle: ", angle.angle, ", Threshold: ", angle.threshold)
#		#print("Start Joint: ", angle.start_joint, ", End Joint: ", angle.end_joint, ", Angle: ", angle.angle, ", Threshold: ", angle.threshold)
		if !IsAngleMatched(landmark_coords, angle):
			pose_matched = false
			angle.matched = false
		else:
			angle.matched = true
	return pose_matched

func ContinuousPoseMatching(landmark_coords: Dictionary):
	for pose in PoseLib_instance.poseLib:
		#print(pose.title)
		if IsMatched(landmark_coords, pose):
			print("Matched: ", pose.title)
			call_deferred("update_label_text", pose)
			var signal_name = pose.title + '_Signal'
			call_deferred("_emit_signal", signal_name)
		else:
			call_deferred("_emit_signal", 'NoPose')
			pass
	checkWingMotion(landmark_coords)

var last_tpose_time: float = 0.0
var last_flapping_time: float = 0.0
var flapping_wings_in_progress: bool = false
var max_time_between_poses: float = 2000.0 
var max_time_after_sequence: float = 1000.0 
var max_time_without_flapping: float = 5000.0 

func checkWingMotion(landmark_coords: Dictionary):
	var tpose_detected : bool = IsMatched(landmark_coords, PoseLib_instance.poseLib[0])
	var armsdown_detected : bool = IsMatched(landmark_coords, PoseLib_instance.poseLib[3])
	var currT = Time.get_ticks_msec()
	#print(currT)
	if tpose_detected:
		last_tpose_time = Time.get_ticks_msec()
	elif armsdown_detected and (Time.get_ticks_msec() - last_tpose_time) <= max_time_between_poses:
		flapping_wings_in_progress = true
		last_flapping_time = Time.get_ticks_msec()
	if Time.get_ticks_msec() - last_flapping_time > max_time_after_sequence:
		flapping_wings_in_progress = false
	if not flapping_wings_in_progress and (Time.get_ticks_msec() - last_flapping_time) >= max_time_without_flapping:
		pass
	elif flapping_wings_in_progress:
		print('Flapping')
		call_deferred("_emit_signal", 'FlapWing_Signal')
		flapping_wings_in_progress = false
	

func update_label_text(pose: Pose):
	if label:  # Check if label is set
		label.text = "Matched: %s" % pose.title
		label.queue_redraw()  # Ensure the label is redrawn

func _emit_signal(signal_name: String):
	if GlobalSignal.has_signal(signal_name):
		GlobalSignal.emit_signal(signal_name)
