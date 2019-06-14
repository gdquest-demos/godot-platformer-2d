extends Position2D
class_name Hook
"""
Throws a raycast that can interact with Hookable bodies and calculate a pull vector towards those bodies.
The raycast is updated manually for greater precision with where the player is aiming
"""


signal hooked_onto_target(target_global_position)

onready var ray: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var hint: Node2D = $TargetHint
onready var target_circle: Node2D = $TargetCircle
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown
onready var length: = ray.cast_to.length()

const HOOKABLE_PHYSICS_LAYER: = 2

var aim_mode: = false setget set_aim_mode


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		self.aim_mode = not aim_mode
		get_tree().set_input_as_handled()


func set_aim_mode(value: bool) -> void:
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


func _get_target_position() -> Vector2:
	return snap_detector.target.global_position if snap_detector.target else ray.get_collision_point()


func _get_hook_target() -> HookTarget:
	return snap_detector.target


func _get_aim_direction() -> Vector2:
	match Settings.controls:
		Settings.GAMEPAD:
			return ControlUtils.get_aim_joystick_direction()
		Settings.KBD_MOUSE, _:
			return (get_global_mouse_position() - global_position).normalized()
