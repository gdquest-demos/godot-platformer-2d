extends Position2D
class_name Hook
"""
throws a raycast that can interact with Hookable bodies and calculate a pull vector towards those bodies
The raycast is updated manually for greater precision with where the player is aiming
"""

signal hooked_onto_target(pull_force)

export var PULL_BASE_FORCE: = 2500.0

onready var ray: RayCast2D = $RayCast2D
onready var arrow: = $Arrow
onready var hint: = $TargetHint
onready var target_circle: = $TargetCircle
onready var snap_detector: = $SnapDetector
onready var cooldown: Timer = $Cooldown

onready var length = ray.cast_to.length()

const HOOKABLE_PHYSICS_LAYER: = 2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and _can_hook():
		cooldown.start()
		arrow.hook_position = snap_detector.target.global_position if snap_detector.target else ray.get_collision_point()
		emit_signal("hooked_onto_target", _calculate_pull_force())


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


func _has_target() -> bool:
	var has_target: bool = snap_detector.has_target()
	if not has_target and ray.is_colliding():
		var collider: PhysicsBody2D = ray.get_collider()
		has_target = collider.get_collision_layer_bit(HOOKABLE_PHYSICS_LAYER)
	return has_target


func _can_hook() -> bool:
	return _has_target() and cooldown.is_stopped()


func _calculate_pull_force() -> Vector2:
	var target_position: Vector2 = snap_detector.target.global_position if snap_detector.target else ray.get_collision_point()
	var to_target: = target_position - global_position
	var direction: = to_target.normalized()
	var distance: = to_target.length()
	return PULL_BASE_FORCE * pow(distance / length, 0.6) * direction


func _get_aim_direction() -> Vector2:
	match Settings.controls:
		Settings.GAMEPAD:
			return Vector2(
				Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
				Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized()
		Settings.KBD_MOUSE, _:
			return (get_global_mouse_position() - global_position).normalized()
