extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and owner.can_hook():
		_state_machine.transition_to("Aim/Fire")


func physics_process(delta: float) -> void:
	owner.ray.cast_to = owner.get_aim_direction() * owner.ray.cast_to.length()
	owner.target_circle.rotation = owner.ray.cast_to.angle()
	owner.snap_detector.rotation = owner.ray.cast_to.angle()
	owner.ray.force_raycast_update()
	
	var has_target: bool = owner.has_target()
	if has_target:
		owner.hint.global_position = owner.ray.get_collision_point()
	
	owner.hint.visible = has_target and not owner.snap_detector.target
	owner.hint.color = owner.hint.color_hook if owner.cooldown.is_stopped() else owner.hint.color_cooldown