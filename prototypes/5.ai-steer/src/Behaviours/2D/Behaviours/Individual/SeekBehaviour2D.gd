extends SteeringBehaviour2D
class_name SeekBehaviour2D

var target

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	motion.linear_motion = (_target() - steerable().position).normalized() * controller.max_linear_acceleration
	motion.rotational_motion = 0
	return motion


func _target() -> Vector2:
	if target is Vector2:
		return target
	elif target is Node2D:
		return target.position
	else:
		return steerable().position