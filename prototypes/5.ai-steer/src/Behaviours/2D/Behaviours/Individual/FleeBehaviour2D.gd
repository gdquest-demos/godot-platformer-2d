extends SeekBehaviour2D
class_name FleeBehaviour2D

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.linear_motion *= -1
	return motion