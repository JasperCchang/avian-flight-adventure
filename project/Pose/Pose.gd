extends Resource
class_name Pose

enum PoseLandmark {
	NOSE = 0,
	LEFT_EYE_INNER,
	LEFT_EYE,
	LEFT_EYE_OUTER,
	RIGHT_EYE_INNER,
	RIGHT_EYE,
	RIGHT_EYE_OUTER,
	LEFT_EAR,
	RIGHT_EAR,
	MOUTH_LEFT,
	MOUTH_RIGHT,
	LEFT_SHOULDER,
	RIGHT_SHOULDER,
	LEFT_ELBOW,
	RIGHT_ELBOW,
	LEFT_WRIST,
	RIGHT_WRIST,
	LEFT_PINKY,
	RIGHT_PINKY,
	LEFT_INDEX,
	RIGHT_INDEX,
	LEFT_HIP,
	RIGHT_HIP,
	LEFT_KNEE,
	RIGHT_KNEE,
	LEFT_ANKLE,
	RIGHT_ANKLE,
	LEFT_HEEL,
	RIGHT_HEEL,
	LEFT_FOOT_INDEX,
	RIGHT_FOOT_INDEX
}

class PoseAngle:
	var start_joint: PoseLandmark
	var end_joint: PoseLandmark
	var angle: float
	var threshold: float
	var matched: bool = false
	
	func _init(sj: PoseLandmark, ej: PoseLandmark, a: float, t: float):
		start_joint = sj
		end_joint = ej
		angle = a
		threshold = t

var title: String
var angles: Array  # Array of PoseAngle instances

# Constructor
func _init(title: String, angles: Array):
	self.title = title
	self.angles = angles
