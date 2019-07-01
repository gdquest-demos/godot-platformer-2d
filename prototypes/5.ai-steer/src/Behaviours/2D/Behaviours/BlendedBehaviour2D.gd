extends SteeringBehaviour2D
class_name BlendedBehaviour2D

export(float) var weight: float = 1

var internal_motion: = SteeringMotion2D.new()

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	motion.zero()

	for child in get_children():
		if !(child is SteeringBehaviour2D):
			continue
		
		var steering: = child as SteeringBehaviour2D
		steering.calculate_steering(internal_motion)
		motion.linear_motion += (internal_motion.linear_motion * weight)
		motion.rotational_motion += (internal_motion.rotational_motion * weight)
	
	motion.linear_motion.clamped(controller.max_linear_acceleration)
	motion.rotational_motion = min(controller.max_rotational_acceleration, motion.rotational_motion)
	
	return motion