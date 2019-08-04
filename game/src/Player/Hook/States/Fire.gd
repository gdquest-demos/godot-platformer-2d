extends State


func _setup() -> void:
	owner.cooldown.connect("timeout", self, "_on_Cooldown_timeout")


func _on_Cooldown_timeout() -> void:
	_state_machine.transition_to("Aim")


func enter(msg: Dictionary = {}) -> void:
	owner.is_aiming = false
	owner.cooldown.start()

	var target: HookTarget = owner.get_hook_target()
	if target:
		owner.arrow.hook_position = owner.snap_detector.target.global_position
		target.hooked_from(owner.global_position)
	else:
		owner.arrow.hook_position = owner.ray_cast.get_collision_point()

	owner.emit_signal("hooked_onto_target", owner.get_target_position())


func physics_process(delta: float) -> void:
	get_parent().physics_process(delta)


