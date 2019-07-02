extends SteeringBehaviour2D
class_name ArriveBehaviour2D
"""
A behaviour that aims to arrive at where the target is, smoothly and within an acceptable distance threshold.

`arrival_tolerance` is the distance away from the target that will be good enough to stop moving.
`deceleration_radius` is the distance away from the target that the AI should begin weighing down its acceleration
and slow down.
`time_to_target` is a fixed time scale value of time by which it should weigh its velocity by to arrive smoothly.
This value should be small and defaults to 0.1.

Supported targets are Vector2 and Node2D.
"""

export(float) var arrival_tolerance: float
export(float) var deceleration_radius: float
export(float) var time_to_target: float = 0.1

var target

"""
Returns the steering motion filled with a linear acceleration amount that will take it towards the target with a
smooth deceleration, or zero if it is already inside of an arrival threshold.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	var to_target: = _to_target()
	var distance: = to_target.length()
	
	if distance <= arrival_tolerance:
		motion.zero()
	else:
		var target_speed: = controller.max_linear_speed
		if distance <= deceleration_radius:
			target_speed *= distance / deceleration_radius
		
		var target_velocity: = to_target.normalized() * target_speed
		target_velocity = (target_velocity - controller.current_linear_velocity) * (1.0 / time_to_target)
		
		motion.linear_motion = target_velocity.clamped(controller.max_linear_acceleration)
		motion.rotational_motion = 0
	
	return motion


"""
Returns the target's position.
"""
func _to_target() -> Vector2:
	if target is Vector2:
		return target - steerable().position
	elif target is Node2D:
		return target.position - steerable().position
	else:
		return steerable().position