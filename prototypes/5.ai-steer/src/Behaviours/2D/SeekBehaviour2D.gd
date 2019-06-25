extends SteeringBehaviour2D
class_name SeekBehaviour2D

var target: Node2D

func _calculate_steering_internal() -> SteeringMotion2D:
	if target == null:
		return SteeringMotion2D.new()
	
	var motion: = SteeringMotion2D.new()
	var controller_position: = _controller.steering_owner.position
	
	motion.linear_motion = (target.position - controller_position).normalized() * _controller.max_linear_acceleration
	motion.rotational_motion = 0
	return motion