extends SeekBehaviour2D
class_name FleeBehaviour2D

func _calculate_steering_internal() -> SteeringMotion2D:
	var motion: = ._calculate_steering_internal()
	motion.linear_motion *= -1
	return motion