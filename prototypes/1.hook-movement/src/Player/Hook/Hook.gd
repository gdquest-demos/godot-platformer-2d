extends Position2D
class_name Hook
"""
Throws a raycast that can interact with Hookable bodies and calculate a pull vector towards those bodies.
The raycast is updated manually for greater precision with where the player is aiming
"""


signal hooked_onto_target(target_position)

onready var ray: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var hint: Node2D = $TargetHint
onready var target_circle: Node2D = $TargetCircle
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

onready var length: float = ray.cast_to.length()

const HOOKABLE_PHYSICS_LAYER: = 2

var aim_mode: = false setget set_aim_mode


func _physics_process(delta: float) -> void:
	ray.cast_to = _get_aim_direction() * length
	target_circle.rotation = ray.cast_to.angle()
	snap_detector.rotation = ray.cast_to.angle()
	ray.force_raycast_update()
	
	var has_target: = _has_target()
	if has_target:
		hint.global_position = ray.get_collision_point()
	
	hint.visible = has_target and not snap_detector.target
	hint.color = hint.color_hook if cooldown.is_stopped() else hint.color_cooldown


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and _can_hook():
		_hook()
		get_tree().set_input_as_handled()

	if event.is_action_pressed("aim"):
		self.aim_mode = not aim_mode
		get_tree().set_input_as_handled()


func _hook() -> void:
	cooldown.start()
	arrow.hook_position = snap_detector.target.global_position if snap_detector.target else ray.get_collision_point()
	if aim_mode:
		self.aim_mode = false
	emit_signal("hooked_onto_target", _get_hook_position())


func set_aim_mode(value:bool) -> void:
	aim_mode = value
	Engine.time_scale = 0.05 if aim_mode == true else 1.0


func _has_target() -> bool:
	var has_target: bool = snap_detector.has_target()
	if not has_target and ray.is_colliding():
		var collider: PhysicsBody2D = ray.get_collider()
		has_target = collider.get_collision_layer_bit(HOOKABLE_PHYSICS_LAYER)
	return has_target


func _can_hook() -> bool:
	return _has_target() and cooldown.is_stopped()


func _get_hook_position() -> Vector2:
	return snap_detector.target.global_position if snap_detector.target else ray.get_collision_point()


func _get_aim_direction() -> Vector2:
	match Settings.controls:
		Settings.GAMEPAD:
			return get_aim_joystick_direction()
		Settings.KBD_MOUSE, _:
			return (get_global_mouse_position() - global_position).normalized()


# FIXME
static func get_aim_joystick_direction() -> Vector2:
	var use_right_stick: bool = ProjectSettings.get_setting('debug/testing/controls/use_right_stick')
	
	# FIXME: axes should be 2 and 3, or RX and RY, is there a calibration issue with the gamepad?
	if use_right_stick:
		return Vector2(
			Input.get_joy_axis(0, JOY_AXIS_3), 
			Input.get_joy_axis(0, JOY_AXIS_4)).normalized()
	else:
		return Vector2(
			Input.get_joy_axis(0, JOY_AXIS_0), 
			Input.get_joy_axis(0, JOY_AXIS_1)).normalized()
