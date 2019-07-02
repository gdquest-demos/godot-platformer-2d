extends SeekBehavior2D
class_name FleeBehavior2D
"""
FleeBehavior2D is the opposite of Seek. It constantly accelerates away from the target.
"""

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.motion *= -1
	return motion
