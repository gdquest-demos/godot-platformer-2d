extends Position2D


onready var _camera: Camera2D = $Camera2D
onready var _tween : Tween = $Tween

export var offset: = Vector2(200.0, 160.0)
export var mouse_range: = Vector2(100.0, 500.0)

var inactive := false

func _ready() -> void:
	assert mouse_range.x < mouse_range.y
	assert mouse_range.x >= 0.0 and mouse_range.y >= 0.0
	Events.connect("player_died", self, "_on_Events_player_died")


func _on_Events_player_died() -> void:
	inactive = true
	var screen_center := to_global(Vector2.ZERO)
	_tween.interpolate_property(_camera, "zoom",
		_camera.zoom, _camera.zoom - Vector2(0.3, 0.3), Defaults.DEATH_ANIMATION_TIME,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(_camera, "global_position",
		_camera.global_position, screen_center, Defaults.DEATH_ANIMATION_TIME,
		Tween.TRANS_QUINT, Tween.EASE_OUT)
	_tween.start()


func update_position(velocity:Vector2) -> void:
	"""Updates the camera rig's position based on the player's state and controller position"""
	if inactive:
		return
	match Settings.controls:
		Settings.KBD_MOUSE:
			var mouse_position: = get_local_mouse_position()
			var distance_ratio: = clamp(mouse_position.length(), mouse_range.x, mouse_range.y) / mouse_range.y
			_camera.position = distance_ratio * mouse_position.normalized() * offset
		
		Settings.GAMEPAD:
			var joystick_direction: Vector2 = ControlUtils.get_aim_joystick_direction()
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				_camera.position.x = sign(velocity.x) * offset.x
			_camera.position.y = joystick_direction.y * offset.y

