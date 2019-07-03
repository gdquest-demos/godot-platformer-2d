extends SteeringBehavior2D
class_name AlignBehavior2D
"""Tries to rotate itself to match the target's own rotation.

Properties:

- `alignment_tolerance` is there to prevent flicker, so as to not constantly
overshoot and start rotating back the other way.
- `deceleration_radius` is the interval of degrees to begin slowing down the
rotation
- `time_to_target` is the amount of time in a fixed time scale
to weight the amount of rotation by. It should be a small value,
and defaults to 0.1.

The only target supported is Node2D and should be fed in ahead of time.
"""


export var deceleration_radius: = 0.0
export var alignment_tolerance: = 0.0
export var time_to_target: = 0.1

var target: Node2D


"""
Returns a steering motion that has no linear acceleration but a angular acceleration that will
match its own to its target's orientation.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if not target:
		return motion.reset_values()
	return _align(motion, target.rotation)


"""
The internal function that calculates the alignment based on the radians passed into the function.
Returns the steering motion with the angular acceleration that will match its own to the rotation value.
"""
func _align(motion: SteeringMotion2D, desired_rotation: float) -> SteeringMotion2D:
	var rotation_size: = abs(desired_rotation - get_actor().rotation)
	var alignment_tolerance_rad: = deg2rad(alignment_tolerance)

	if rotation_size <= alignment_tolerance_rad:
		motion.reset_values()
	else:
		var target_rotation: = deg2rad(controller.max_rotation_speed)
		var deceleration_radius_rad: = deg2rad(deceleration_radius)

		if rotation_size <= deceleration_radius_rad:
			target_rotation *= rotation_size / deceleration_radius_rad
		target_rotation *= desired_rotation / rotation_size

		motion.angular_motion = (target_rotation - controller.angular_velocity) / time_to_target

		var angular_acceleration: = abs(motion.angular_motion)
		var max_angular_acceleration_rad: = deg2rad(controller.max_angular_acceleration)
		if angular_acceleration > max_angular_acceleration_rad:
			motion.angular_motion *= max_angular_acceleration_rad / angular_acceleration

		motion.motion = Vector2.ZERO

	return motion
