extends SteeringBehavior2D
class_name AlignBehavior2D
"""
A behavior that tries to rotate itself to match the target's own rotation.

The `alignment_tolerance` is there to prevent flicker, so as to not constantly overshoot
and start rotating back the other way. The `deceleration_radius` is the interval of degrees
to begin slowing down the act of rotating, and the `time_to_target` is the amount of time
in a fixed time scale to weight the amount of rotation by. It should be a small value, and
defaults to 0.1.

The only target supported is Node2D and should be fed in ahead of time.
"""

export(float) var deceleration_radius: float
export(float) var alignment_tolerance: float
export(float) var time_to_target: float = 0.1

var target: Node2D

"""
Returns a steering motion that has no linear acceleration but a rotational acceleration that will
match its own to its target's orientation.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	return _align(motion, target.rotation)


"""
The internal function that calculates the alignment based on the radians passed into the function.
Returns the steering motion with the rotational acceleration that will match its own to the rotation value.
"""
func _align(motion: SteeringMotion2D, desired_rotation: float) -> SteeringMotion2D:
	var rotation_size: = abs(desired_rotation - steerable().rotation)
	var alignment_tolerance_rad: = deg2rad(alignment_tolerance)
	
	if rotation_size <= alignment_tolerance_rad:
		motion.zero()
	else:
		var target_rotation: = deg2rad(controller.max_rotation_speed)
		var deceleration_radius_rad: = deg2rad(deceleration_radius)
		
		if rotation_size <= deceleration_radius_rad:
			target_rotation *= rotation_size / deceleration_radius_rad
		target_rotation *= desired_rotation / rotation_size
		
		motion.rotational_motion = (target_rotation - controller.current_rotation_velocity) / time_to_target
		
		var rotational_acceleration: = abs(motion.rotational_motion)
		var max_rotational_acceleration_rad: = deg2rad(controller.max_rotational_acceleration)
		if rotational_acceleration > max_rotational_acceleration_rad:
			motion.rotational_motion *= max_rotational_acceleration_rad / rotational_acceleration
		
		motion.linear_motion.x = 0
		motion.linear_motion.y = 0
	
	return motion