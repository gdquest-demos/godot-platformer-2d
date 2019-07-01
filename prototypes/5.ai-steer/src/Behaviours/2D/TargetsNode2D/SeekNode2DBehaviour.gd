extends SteeringBehaviour2D
class_name SeekNode2DBehaviour

var target: Node2D

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	var controller_position: = steerable().position
	
	motion.linear_motion = (target.position - controller_position).normalized() * controller.max_linear_speed
	motion.rotational_motion = 0
	return motion