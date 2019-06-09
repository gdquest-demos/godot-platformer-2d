extends Node


onready var hook: Hook = $"../.."


func _physics_process(delta: float) -> void:
	hook.ray.cast_to = hook._get_aim_direction() * hook.ray.cast_to.length()
	hook.target_circle.rotation = hook.ray.cast_to.angle()
	hook.snap_detector.rotation = hook.ray.cast_to.angle()
	hook.ray.force_raycast_update()
	
	var has_target: = hook._has_target()
	if has_target:
		hook.hint.global_position = hook.ray.get_collision_point()
	
	hook.hint.visible = has_target and not hook.snap_detector.target
	hook.hint.color = hook.hint.color_hook if hook.cooldown.is_stopped() else hook.hint.color_cooldown


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and hook._can_hook():
		_hook()
		get_tree().set_input_as_handled()


func _hook() -> void:
	hook.cooldown.start()
	hook.arrow.hook_position = (
			hook.snap_detector.target.global_position
			if hook.snap_detector.target
			else hook.ray.get_collision_point())
	if hook.aim_mode:
		hook.aim_mode = false
	hook.emit_signal("hooked_onto_target", hook._get_hook_position())