extends "res://mediapipe_parent.gd"

func _ready():
	#processed_frame.resize(66)
	#processed_frame.fill(0)
	
	#Start the camera
	$CameraTimer.start()
	camera_helper.permission_result.connect(self._permission_result)
	camera_helper.new_frame.connect(self._camera_frame)
	if OS.get_name() == "Android":
		var gpu_resources := MediaPipeGPUResources.new()
		camera_helper.set_gpu_resources(gpu_resources)
	#Start the load mediapipe function
	init_task()
	
func _process(delta):
	pass

	
# open camera
func _open_camera() -> void:
	if camera_helper.permission_granted():
		start_camera()
	else:
		camera_helper.request_permission()
#to close camera
#simply use "camera_helper.close()"

func _on_camera_timer_timeout():
	_open_camera()
	$CameraTimer.stop()
	
	


