extends SteeringBehaviour2D
class_name ArriveBehaviour2D

export(float) var arrival_tolerance: float
export(float) var deceleration_radius: float
export(float) var time_to_target: float = 0.1

var target

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	var to_target: = _to_target()
	var distance: = to_target.length()
	
	if distance <= arrival_tolerance:
		motion.zero()
	else:
		var target_speed: = controller.max_linear_speed
		if distance <= deceleration_radius:
			target_speed *= distance / deceleration_radius
		
		var target_velocity: = to_target.normalized() * target_speed
		target_velocity = (target_velocity - controller.current_linear_velocity) * (1.0 / time_to_target)
		
		motion.linear_motion = target_velocity.clamped(controller.max_linear_acceleration)
		motion.rotational_motion = 0
	
	return motion


func _arrive_vector(motion: SteeringMotion2D) -> SteeringMotion2D:
	return motion.zero()


func _to_target() -> Vector2:
	if target is Vector2:
		return target - steerable().position
	elif target is Node2D:
		return target.position - steerable().position
	else:
		return steerable().position