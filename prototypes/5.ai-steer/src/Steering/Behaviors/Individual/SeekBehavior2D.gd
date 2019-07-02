extends SteeringBehavior2D
class_name SeekBehavior2D
"""
A behavior that will constantly accelerate towards the target as fast as it can accelerate.

Supported targets are Node2D and Vector2.
"""

var target

"""
Returns the steering motion filled with a linear acceleration amount that will make it go to where
the target currently is, as fast as it is allowed by the controller.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	motion.linear_motion = (_target() - steerable().position).normalized() * controller.max_linear_acceleration
	motion.rotational_motion = 0
	return motion


"""
Returns the target's position.
"""
func _target() -> Vector2:
	if target is Vector2:
		return target
	elif target is Node2D:
		return target.position
	else:
		return steerable().position