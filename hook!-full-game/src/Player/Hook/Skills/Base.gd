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
	if not hook.cooldown.is_stopped():
		return
	_snap_hook_arrow_tip()
	_disable_hook_aim()
	_handle_hook_target()
	_trigger_hook_cooldown()


func _snap_hook_arrow_tip() -> void:
	var snap_position: Vector2 = hook.ray.get_collision_point()
	if hook.snap_detector.target:
		snap_position = hook.snap_detector.target.global_position
	hook.arrow.hook_position= snap_position


func _trigger_hook_cooldown() -> void:
	hook.cooldown.start()


func _disable_hook_aim() -> void:
	if hook.aim_mode:
		hook.aim_mode = false


func _handle_hook_target() -> void:
	var target: HookTarget = hook._get_hook_target()
	if target:
		target.hooked_from(hook.global_position)
		if not target.is_in_group("enemy"):
			hook.emit_signal("hooked_onto_target", hook._get_target_position())
