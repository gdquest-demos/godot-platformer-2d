extends SteeringBehaviour2D
class_name OrientBehaviour2D

var target: Node2D
var alignment_tolerance: float
var deceleration_radius: float
var time_to_target: float = 0.1

func _calculate_steering_internal() -> SteeringMotion2D:
	if target == null:
		return SteeringMotion2D.new()
	
	var rotation: = target.rotation - _controller.steering_owner.rotation
	var wrapped_rotation: = rotation
	if rotation >= 0:
		rotation = fmod(wrapped_rotation, 360)
		if rotation > 180:
			rotation -= 360
	else:
		rotation = fmod(-wrapped_rotation, 360)
		if rotation > 180:
			rotation -= 360
		rotation *= -1
	
	var rotation_size = rotation
	if rotation < 0:
		rotation_size *= -1
	
	if rotation_size <= alignment_tolerance:
		return SteeringMotion2D.new()
	
	var target_rotation: = _controller.max_rotational_speed
	if rotation_size <= deceleration_radius:
		target_rotation *= rotation_size / deceleration_radius
	
	target_rotation *= rotation / rotation_size
	
	var motion: = SteeringMotion2D.new()
	
	motion.rotational_motion = (target_rotation - _controller.current_rotational_velocity) / time_to_target
	
	var rotational_acceleration: = motion.rotational_motion
	if motion.rotational_motion < 0:
		rotational_acceleration *= -1
	
	if rotational_acceleration > _controller.max_rotational_speed:
		motion.rotational_motion *= _controller.max_rotational_speed / rotational_acceleration
	
	motion.linear_motion.x = 0
	motion.linear_motion.y = 0
	
	return motion