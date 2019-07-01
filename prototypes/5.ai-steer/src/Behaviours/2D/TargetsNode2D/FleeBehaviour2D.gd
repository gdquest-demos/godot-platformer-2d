extends SeekNode2DBehaviour
class_name FleeNode2DBehaviour

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.linear_motion *= -1
	return motion