extends SteeringBehavior2D
class_name BlendedBehavior2D
"""
A behavior that runs through all of its children and blends all motions together by a defined weight.

The blended behavior will first calculate a child's motion, will multiply iy by its weight, then add it
to the motion buffer before returning it. It will be clamped to the controller's maximums.
The weights are not relative to 1, and instead act as a multiplier on the strength of the behavior.
The index of a given weight in the array should refer to the given index of its child.

Notes
-----
More complex behaviors can be built with a blended behavior than an indivudal one without writing
a complex, custom behavior, but it is more costly to run since all children will be evaluated. Figuring
out the amount of weight to give each behavior can also be a non-trivial, manual problem.

It can also lead to conflicts of force which may cause unusual behavior.

The general workflow should be to have a priority steering with a set of blended behaviors, based on need.
"""

export(Array) var weights: = []

var _internal_motion: = SteeringMotion2D.new()

"""
Returns the steering motion with a blend of all of the behavior's children, capped by the controller's maximums.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	motion.zero()

	var size: = get_child_count()
	for i in range(0, size):
		var child: = get_child(i) as SteeringBehavior2D
		if child == null:
			continue
		
		var steering: = child as SteeringBehavior2D
		steering.calculate_steering(_internal_motion)
		
		var weight: float = 1
		if weights.size() >= i:
			weight = weights[i]
		
		motion.linear_motion += (_internal_motion.linear_motion * weight)
		motion.rotational_motion += (_internal_motion.rotational_motion * weight)
	
	motion.linear_motion.clamped(controller.max_linear_acceleration)
	motion.rotational_motion = min(controller.max_rotational_acceleration, motion.rotational_motion)
	
	return motion