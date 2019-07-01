extends SeekVector2Behaviour
class_name FleeVector2Behaviour

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.linear_motion *= -1
	return motion