extends State


func physics_process(delta: float) -> void:
	get_parent().physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	owner.is_aiming = false
	owner.cooldown.start()
	
	owner.arrow.hook_position = (
			owner.snap_detector.target.global_position
			if owner.snap_detector.target
			else owner.ray.get_collision_point())

	var target: HookTarget = owner.get_hook_target()
	if target:
		target.hooked_from(owner.global_position)
	
	owner.emit_signal("hooked_onto_target", owner.get_target_position())
	_state_machine.transition_to("Aim")
