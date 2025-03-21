extends VisionTask

var task: MediaPipeHandLandmarker
var task_file := "res://vision/hand_landmarker/hand_landmarker.task"

@onready var lbl_handedness: Label = $VBoxContainer/Image/Handedness

func _result_callback(result: MediaPipeHandLandmarkerResult, image: MediaPipeImage, timestamp_ms: int) -> void:
	var img := image.get_image()
	show_result(img, result)

func init_task() -> void:
	var base_options := MediaPipeTaskBaseOptions.new()
	base_options.delegate = delegate
	var file := FileAccess.open(task_file, FileAccess.READ)
	base_options.model_asset_buffer = file.get_buffer(file.get_length())
	task = MediaPipeHandLandmarker.new()
	task.initialize(base_options, running_mode)
	task.result_callback.connect(self._result_callback)

func process_image_frame(image: Image) -> void:
	var input_image := MediaPipeImage.new()
	input_image.set_image(image)
	var result := task.detect(input_image)
	show_result(image, result)

func process_video_frame(image: Image, timestamp_ms: int) -> void:
	var input_image := MediaPipeImage.new()
	input_image.set_image(image)
	var result := task.detect_video(input_image, timestamp_ms)
	show_result(image, result)

func process_camera_frame(image: MediaPipeImage, timestamp_ms: int) -> void:
	task.detect_async(image, timestamp_ms)

func show_result(image: Image, result: MediaPipeHandLandmarkerResult) -> void:
	for landmarks in result.hand_landmarks:
		draw_landmarks(image, landmarks)
	var handedness_text := ""
	for categories in result.handedness:
		for category in categories.categories:
			handedness_text += "%s\n" % [category.display_name]
	lbl_handedness.call_deferred("set_text", handedness_text)
	update_image(image)

func draw_landmarks(image: Image, landmarks: MediaPipeNormalizedLandmarks) -> void:
	var color := Color.GREEN
	var rect := Image.create(4, 4, false, image.get_format())
	rect.fill(color)
	var image_size := Vector2(image.get_size())
	for landmark in landmarks.landmarks:
		var pos := Vector2(landmark.x, landmark.y)
		
		image.blit_rect(rect, rect.get_used_rect(), Vector2i(image_size * pos) - rect.get_size() / 2)
