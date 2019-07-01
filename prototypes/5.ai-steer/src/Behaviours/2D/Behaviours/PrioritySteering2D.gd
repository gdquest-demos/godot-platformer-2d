extends SteeringBehaviour2D
class_name PrioritySteering2D

var last_selected_child_idx: int

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	last_selected_child_idx = -1
	var size: = get_child_count()
	
	for i in range(0, size):
		last_selected_child_idx = i
		var child: = get_child(i) as SteeringBehaviour2D
		if child == null:
			continue
		
		child.calculate_steering(motion)
		if motion.linear_motion.length_squared() != 0 or motion.rotational_motion != 0:
			break
	
	if size > 0:
		return motion
	else:
		return motion.zero()