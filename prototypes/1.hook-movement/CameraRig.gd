extends Position2D

onready var _camera: Camera2D = $Camera2D

export var offset: = Vector2(200.0, 160.0)
export var mouse_range: = Vector2(100.0, 500.0)


func _ready() -> void:
	assert mouse_range.x < mouse_range.y
	assert mouse_range.x >= 0.0 and mouse_range.y >= 0.0


func update_position(velocity:Vector2) -> void:
	"""Updates the camera rig's position based on the player's state and controller position"""
	match Settings.controls:
		Settings.KBD_MOUSE:
			var mouse_position: = get_local_mouse_position()
			var distance_ratio: = clamp(mouse_position.length(), mouse_range.x, mouse_range.y) / mouse_range.y
			_camera.position = distance_ratio * mouse_position.normalized() * offset
		
		Settings.GAMEPAD:
			var joystick_direction: = get_aim_joystick_direction()
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				_camera.position.x = sign(velocity.x) * offset.x
			_camera.position.y = joystick_direction.y * offset.y

