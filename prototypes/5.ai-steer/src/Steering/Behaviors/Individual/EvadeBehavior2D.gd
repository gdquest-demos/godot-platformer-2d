extends InterceptBehavior2D
class_name EvadeBehavior2D
"""
EvadeBehavior2D is the opposite of Intercept. It moves away from the target's projected position.
See `InterceptBehavior2D` for more information.

"""

"""
Returns a steering motion filled with a linear acceleration amount that will move it away from the
point where the target will be in `max_prediction_time`.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(motion)
	motion.motion *= -1
	return motion
