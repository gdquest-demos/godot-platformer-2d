extends SteeringBehavior2D
class_name PrioritySteering2D
# Runs from top to bottom through its children, a collection of
# SteeringBehavior2D nodes, requests each to calculate its steering, and stops
# once one of them returns non-zero steering.

# # PrioritySteering2D gives priority to the behaviors at the top of its child list.

# # Notes
# -----
# Some behaviors will always return an acceleration amount, while others may not. You
# usually want to act on them. For instance, evading an obstacle to avoid impact.


var last_child_index := 0


# Returns the child whose motion was non-zero. Returns null if no children produced an acceleration.
func get_last_selected_child() -> SteeringBehavior2D:
	assert(last_child_index >= 0)
	return get_child(last_child_index) as SteeringBehavior2D


# Fills the steering motion object with the first non-zero calculation it can find. The priority goes from
# top to bottom.
func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	last_child_index = -1
	var size := get_child_count()

	for i in range(0, size):
		var child := get_child(i) as SteeringBehavior2D
		if child == null:
			continue

		child.calculate_steering(steering)
		if !steering.is_zero():
			last_child_index = i

	if size > 0:
		return steering
	else:
		return steering.reset_values()
