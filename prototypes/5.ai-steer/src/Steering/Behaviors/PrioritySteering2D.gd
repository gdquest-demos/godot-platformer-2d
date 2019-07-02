extends SteeringBehavior2D
class_name PrioritySteering2D
"""
An AI behavior that runs through its children and stops as soon as one returns a non-zero motion.

Runs iteratively from top to bottom down its child-list and stops once one of them returns non-zero motion.
Certain behaviors will always return an acceleration amount, while others may not - in many cases, you
usually want to act on it (for instance, evading an obstacle to avoid impact.)
"""

var last_selected_child_idx: int

"""
Returns the child whose motion was non-zero. Returns null if no children produced an acceleration.
"""
func get_last_selected_child() -> SteeringBehavior2D:
	if last_selected_child_idx >= 0:
		return get_child(last_selected_child_idx) as SteeringBehavior2D
	return null


"""
Fills the steering motion object with the first non-zero calculation it can find. The priority goes from
top to bottom.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	last_selected_child_idx = -1
	var size: = get_child_count()
	
	for i in range(0, size):
		var child: = get_child(i) as SteeringBehavior2D
		if child == null:
			continue
		
		child.calculate_steering(motion)
		if !motion.is_zero():
			last_selected_child_idx = i
			break
	
	if size > 0:
		return motion
	else:
		return motion.zero()