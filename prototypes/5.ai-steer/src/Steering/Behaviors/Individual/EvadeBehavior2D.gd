extends InterceptBehavior2D
class_name EvadeBehavior2D
"""
A behavior that acts as the inverse of Intercept. It will move away from the predicted point where
the target will be. See `InterceptBehavior2D` for more information.

Supported targets are Vector2 and Node2D.
"""

"""
Returns a steering motion filled with a linear acceleration amount that will move it away from the
point where the target will be in `max_prediction_time`.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.linear_motion *= -1
	return motion