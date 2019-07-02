extends SeekBehavior2D
class_name FleeBehavior2D
"""
A behavior that acts like an inverse of Seek - it will constantly accelerate away from the target.

Supported targets are Node2D and Vector2.
"""

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.linear_motion *= -1
	return motion