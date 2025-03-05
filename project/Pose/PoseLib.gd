extends Resource

class_name PoseLib

var poseLib: Array = []
var targetPoseIndex: int
var Pose = preload("res://Pose/Pose.gd")

func populatePoseLib():
	var angles = [
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, 180, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, 180, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, 0, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, 0, 20)
		]
	poseLib.append(Pose.new("Tpose", angles))

	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, -135, 25),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, -135, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, 45, 25),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, 45, 20)
		]
	poseLib.append(Pose.new("Tpose_Right", angles))
#
	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, 135, 25),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, 135 , 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, -45, 25),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, -45, 20)
		]
	poseLib.append(Pose.new("Tpose_Left", angles))
	
	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, 90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, 90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, 90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, 90, 20)
		]
	poseLib.append(Pose.new("Idle_Pose", angles))

	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, 90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, 90, 20)
		]
	poseLib.append(Pose.new("Arms_In", angles))
	
	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, -90, 20)
		]
	poseLib.append(Pose.new("Arms_Up", angles))
	
	angles =[
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_SHOULDER, Pose.PoseLandmark.RIGHT_ELBOW, 180, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, -90, 20),
		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_SHOULDER, Pose.PoseLandmark.LEFT_ELBOW, 0, 20)
		]
	poseLib.append(Pose.new("Arms_L", angles))
	
#	angles =[
#		Pose.PoseAngle.new(Pose.PoseLandmark.RIGHT_ELBOW, Pose.PoseLandmark.RIGHT_WRIST, 45, 20),
#		Pose.PoseAngle.new(Pose.PoseLandmark.LEFT_ELBOW, Pose.PoseLandmark.LEFT_WRIST, 135, 20)
#		]
#	poseLib.append(Pose.new("Arms X", angles))

	print("PoseLib Populated")
