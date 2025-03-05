extends Control

# <--Mediapipe setting
# running mode can be "RUNNING_MODE_IMAGE" / "RUNNINE_MODE_VIDEO" / "RUNNING_MODE_LIVE_STREAM"
var running_mode := MediaPipeTask.RUNNING_MODE_LIVE_STREAM 
var delegate := MediaPipeTaskBaseOptions.DELEGATE_CPU
#if change model, just change the following parameters
var task = MediaPipePoseLandmarker #MediaPipeHandLandmarker MediaPipePoseLandmarker 
var result = MediaPipePoseLandmarkerResult #MediaPipeHandLandmarkerResult MediaPipePoseLandmarkerResult
var result_landmark = "pose_landmarks" #"face_landmarks"/"hand_landmarks" pose_landmarks
var task_file := "res://vision/pose_landmarker/pose_landmarker.task" #"res://vision/hand_landmarker/hand_landmarker.task" res://vision/pose_landmarker/pose_landmarker_lite.task
#-->

var pose_matching_instance: PoseMatching

#textureRect be the window of showing the camera content
@onready var image_view: TextureRect = $Image
#get permission for accessing camera
@onready var permission_dialog: AcceptDialog = $PermissionDialog
#calling mediapipe library to set camera
var camera_helper := MediaPipeCameraHelper.new()

#Start load mediapipe
func init_task() -> void:
	#Declare mediapipe
	var base_options := MediaPipeTaskBaseOptions.new() 
	base_options.delegate = delegate
	
	#Access the model file
	var file := FileAccess.open(task_file, FileAccess.READ) 
	base_options.model_asset_buffer = file.get_buffer(file.get_length())
	task = task.new() 	#task = MediaPipePoseLandmarker.new()
	
	#Initial the model (delegate, running mode image/video/stream, detect how many , min confidence settings... (base on what model choice))
	task.initialize(base_options, running_mode, 1, 0.5, 0.5, 0.5, true)
	
	#connect to function on recieving result
	task.result_callback.connect(self._result_callback)
	
	pose_matching_instance = PoseMatching.new()  # Instantiate PoseMatching
	add_child(pose_matching_instance)  # Add it to the scene tree
	pose_matching_instance._ready()  # Call _ready() explicitly


# <--for camera
func update_image(image: Image) -> void:
	if Vector2i(image_view.texture.get_size()) == image.get_size():
		image_view.texture.call_deferred("update", image)
	else:
		image_view.texture.call_deferred("set_image", image)

func start_camera() -> void:
	reset()
	camera_helper.set_mirrored(true)
	camera_helper.start(MediaPipeCameraHelper.FACING_FRONT, Vector2(640, 480))
	
func reset() -> void:
	#video_player.stop()
	camera_helper.close()
	
func _permission_result(granted: bool) -> void:
	if granted:
		start_camera()
	else:
		permission_dialog.popup_centered()
#-->
		
		
# <--mediapipe model process frames
func _camera_frame(image: MediaPipeImage) -> void:
	if not running_mode == MediaPipeTask.RUNNING_MODE_LIVE_STREAM:
		running_mode = MediaPipeTask.RUNNING_MODE_LIVE_STREAM
	if delegate == MediaPipeTaskBaseOptions.DELEGATE_CPU and image.is_gpu_image():
		image.convert_to_cpu()
	process_camera_frame(image, Time.get_ticks_msec())
	
func process_camera_frame(image: MediaPipeImage, timestamp_ms: int) -> void:
	task.detect_async(image, timestamp_ms)
	
func draw_landmarks(image: Image, landmarks: MediaPipeNormalizedLandmarks) -> void:
	# plot landmarks as green dots
	var color := Color.GREEN
	var rect := Image.create(4, 4, false, image.get_format())
	rect.fill(color)
	var image_size := Vector2(image.get_size())
	
	#draw original landmarks here
	for landmark in landmarks.landmarks:
		var pos := Vector2(landmark.x, landmark.y)
		image.blit_rect(rect, rect.get_used_rect(), Vector2i(image_size * pos) - rect.get_size() / 2)
	
func show_result(image: Image, result, result_landmark) -> void:#MediaPipePoseLandmarkerResult
	for landmarks in result[result_landmark]:
		draw_landmarks(image, landmarks)
		var landmark_coords = {}
		for i in range(landmarks.landmarks.size()):
			var landmark = landmarks.landmarks[i]
			landmark_coords[i] = Vector2(landmark.x, landmark.y)
		pose_matching_instance.ContinuousPoseMatching(landmark_coords)
		#print(landmarks.landmarks[0].x)
	#Show the results on the image
	update_image(image)
	
# get landmarks
func _result_callback(result, image: MediaPipeImage, timestamp_ms: int) -> void:#MediaPipePoseLandmarkerResult
	var img := image.get_image()
	show_result(img, result, result_landmark)

	#get mediapipe unsmoothed landmarks here
	#example
	#result.hand_landmarks[0].landmarks[0]['x'] for hand's wist
	#result.pose_landmarks[0].landmarks[0]['x'] for pose's nose
	
	

