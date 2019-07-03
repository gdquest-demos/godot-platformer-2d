extends SteeringBehavior2D
class_name BlendedBehavior2D
"""
Runs through all of its children and blends all motions together by a defined weight.

The blended behavior first calculates a child's motion, multiplies it by its weight, then adds it
to the motion buffer before returning it. The motion is clamped to the controller's maximums.
The weights are multipliers on the strength of the individual behaviors. They're not scaled down to sum to one.
The index of a given weight in the array should refer to the given index of its child.

Notes
-----
You can build complex behaviors with a blended behavior compared to indivudal ones without writing
a complex, custom behavior. But it is more costly to run since all of BlendedBehavior2D's children are evaluated. 
Figuring out the weight to give each behavior can also be tricky and takes some trial-and-error.

Weights can lead to conflicting forces, which may cause weird behaviors.

The recommended use is to have a priority steering with a set of blended behaviors, based on need.
"""

export var weights: = []

var _internal_motion: = SteeringMotion2D.new()


"""
Returns the steering motion with a blend of all of the behavior's children, clamped to the controller's maximum values.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	motion.reset_values()

	var size: = get_child_count()
	for i in range(0, size):
		var child: = get_child(i) as SteeringBehavior2D
		if not child:
			continue

		var steering: = child as SteeringBehavior2D
		steering.calculate_steering(_internal_motion)

		var weight: = 1.0
		if weights.size() >= i:
			weight = weights[i]

		motion.motion += (_internal_motion.motion * weight)
		motion.angular_motion += (_internal_motion.angular_motion * weight)

	motion.motion.clamped(controller.max_acceleration)
	motion.angular_motion = min(controller.max_angular_acceleration, motion.angular_motion)

	return motion
