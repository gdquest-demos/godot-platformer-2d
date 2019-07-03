extends SteeringBehavior2D
class_name SeekBehavior2D
"""
Constantly accelerates towards the target as fast as it can.
"""


var target: Node2D


"""
Returns the steering motion filled with a linear acceleration amount that will make it go to where
the target currently is, as fast as it is allowed by the controller.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if not target:
		return motion.reset_values()

	motion.motion = (target.position - get_actor().position).normalized() * controller.max_acceleration
	motion.angular_motion = 0
	return motion
