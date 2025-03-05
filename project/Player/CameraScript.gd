extends Camera3D

# The target node to follow (assign this in the editor or via code)
@export var target: NodePath
# How quickly the camera catches up to the target (0 = no movement, 1 = instant)
@export var lerp_speed: float = 1
# Offset from the target's position (e.g., to position the camera behind the bird)
@export var position_offset: Vector3 = Vector3(0, 2, 7)
# Offset from the target's rotation (e.g., to look slightly downward)
@export var rotation_offset: Vector3 = Vector3(-10, 0, 0)

# Internal variable to store the target node
var _target_node: Node3D

func _ready():
	# Ensure the target is valid
	if target:
		_target_node = get_node(target)
	else:
		printerr("SmoothCamera: No target assigned!")

func _process(delta):
	if _target_node:
		# Smoothly interpolate the camera's position
		var target_position = _target_node.global_transform.origin + _target_node.global_transform.basis * position_offset
		global_transform.origin = global_transform.origin.lerp(target_position, lerp_speed)
		
		# Calculate the target rotation
		var target_rotation = _target_node.transform.basis
		var offset_rotation = Basis.from_euler(rotation_offset * PI / 180.0)  # Convert degrees to radians
		target_rotation = target_rotation * offset_rotation
		
		# Interpolate the camera's rotation
		var current_rotation = global_transform.basis
		var new_rotation = current_rotation.slerp(target_rotation, lerp_speed)
		
		# Apply the new rotation to the camera
		global_transform.basis = new_rotation
