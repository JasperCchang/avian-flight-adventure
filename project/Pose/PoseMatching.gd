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
	if(pose_angle.start_joint == 13):
		print("Pose Angle: ", pose_angle.start_joint, " & ", "Pose Angle: ", pose_angle.end_joint, " has an angle of: ", skeletonAngle)
	var angle_diff = AngularDifference(skeletonAngle, pose_angle)
	if(pose_angle.start_joint == 13):
		print("Pose Angle: ", pose_angle.start_joint, " & ", "Pose Angle: ", pose_angle.end_joint, " has an angle diff of: ", angle_diff)
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
			pass

func update_label_text(pose: Pose):
	if label:  # Check if label is set
		label.text = "Matched: %s" % pose.title
		label.queue_redraw()  # Ensure the label is redrawn

func _emit_signal(signal_name: String):
	if GlobalSignal.has_signal(signal_name):
		GlobalSignal.emit_signal(signal_name)
