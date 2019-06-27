extends SteeringBehaviour2D
class_name PrioritySteering2D

func _calculate_steering_internal() -> SteeringMotion2D:
	var result: = SteeringMotion2D.new()
	for child in get_children():
		if !(child is SteeringBehaviour2D):
			continue
		var steering: = child as SteeringBehaviour2D
		var subresult: = steering.calculate_steering()
		if subresult.linear_motion.length() != 0 or subresult.rotation_motion != 0:
			result.linear_motion = subresult.linear_motion
			result.rotational_motion = subresult.rotational_motion
			break
	return result