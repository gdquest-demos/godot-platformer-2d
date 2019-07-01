extends SteeringBehaviour2D
class_name BlendedBehaviour2D
"""
A behaviour that runs through all of its children and blends all motions together by a defined weight.

The blended behaviour will first calculate a child's motion, will multiply iy by its weight, then add it
to the motion buffer before returning it. It will be clamped to the controller's maximums.
The weights are not relative to 1, and instead act as a multiplier on the strength of the behaviour.

Notes
-----
More complex behaviours can be built with a blended behaviour than an indivudal one without writing
a complex, custom behaviour, but it is more costly to run since all children will be evaluated. Figuring
out the amount of weight to give each behaviour can also be a non-trivial, manual problem.

It can also lead to conflicts of force which may cause unusual behaviour.

The general workflow should be to have a priority steering with a set of blended behaviours, based on need.
"""

export(float) var weight: float = 1

var _internal_motion: = SteeringMotion2D.new()

"""
Returns the steering motion with a blend of all of the behaviour's children, capped by the controller's maximums.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	motion.zero()

	for child in get_children():
		if !(child is SteeringBehaviour2D):
			continue
		
		var steering: = child as SteeringBehaviour2D
		steering.calculate_steering(_internal_motion)
		motion.linear_motion += (_internal_motion.linear_motion * weight)
		motion.rotational_motion += (_internal_motion.rotational_motion * weight)
	
	motion.linear_motion.clamped(controller.max_linear_acceleration)
	motion.rotational_motion = min(controller.max_rotational_acceleration, motion.rotational_motion)
	
	return motion