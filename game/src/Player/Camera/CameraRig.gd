extends Position2D
# Rig to move a child camera based on the player's input, to give them more forward visibility


onready var camera: Camera2D = $ShakingCamera

export var offset := Vector2(300.0, 300.0)
export var mouse_range := Vector2(100.0, 500.0)

var is_active := true


func _physics_process(_delta: float) -> void:
	update_position()


func update_position(_velocity: Vector2 = Vector2.ZERO) -> void:
	# Updates the camera rig's position based on the player's state and controller position
	if not is_active:
		return

	match Settings.controls:

		Settings.GAMEPAD:
			var joystick_strength := Utils.get_aim_joystick_strength()
			camera.position = joystick_strength * offset

		Settings.KBD_MOUSE, _:
			var mouse_position := get_local_mouse_position()
			var distance_ratio := clamp(mouse_position.length(), mouse_range.x, mouse_range.y) / mouse_range.y
			camera.position = distance_ratio * mouse_position.normalized() * offset
