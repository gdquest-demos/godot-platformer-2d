extends Position2D
"""
Rig to move a child camera based on the player's input, to give them more forward visibility
"""


onready var camera: Camera2D = $ShakingCamera

export var offset: = Vector2(200.0, 160.0)
export var mouse_range: = Vector2(100.0, 500.0)

var is_active: = true


func _physics_process(delta: float) -> void:
	update_position()


func update_position(velocity: Vector2 = Vector2.ZERO) -> void:
	"""Updates the camera rig's position based on the player's state and controller position"""
	if not is_active:
		return

	match Settings.controls:
		Settings.KBD_MOUSE:
			var mouse_position: = get_local_mouse_position()
			var distance_ratio: = clamp(mouse_position.length(), mouse_range.x, mouse_range.y) / mouse_range.y
			camera.position = distance_ratio * mouse_position.normalized() * offset

		Settings.GAMEPAD:
			var joystick_direction: Vector2 = ControlUtils.get_aim_joystick_direction()
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				camera.position.x = sign(velocity.x) * offset.x
			camera.position.y = joystick_direction.y * offset.y
