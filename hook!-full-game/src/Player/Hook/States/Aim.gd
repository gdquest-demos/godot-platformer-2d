extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		owner.is_aiming = not owner.is_aiming
	elif event.is_action_pressed("hook") and owner.can_hook():
		_state_machine.transition_to("Aim/Fire")


func physics_process(delta: float) -> void:
	owner.ray_cast.cast_to = owner.get_aim_direction() * owner.ray_cast.cast_to.length()
	owner.target_circle.rotation = owner.ray_cast.cast_to.angle()
	owner.snap_detector.rotation = owner.ray_cast.cast_to.angle()
	owner.ray_cast.force_raycast_update()