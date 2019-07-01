extends SteeringBehaviour2D
class_name BlendedBehaviour2D

export(float) var weight: float = 1

var internal_motion: = SteeringMotion2D.new()

func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	motion.zero()

	for child in get_children():
		if !(child is SteeringBehaviour2D):
			continue
		
		var steering: = child as SteeringBehaviour2D
		steering.calculate_steering(internal_motion)
		motion.linear_motion += (internal_motion.linear_motion * weight)
		motion.rotational_motion += (internal_motion.rotational_motion * weight)
	
	var length2: = motion.linear_motion.length_squared()
	var limit2: = controller.max_linear_speed * controller.max_linear_speed
	if length2 > limit2:
		motion.linear_motion = motion.linear_motion * sqrt(limit2 / length2)
	
	if motion.rotational_motion > controller.max_rotation_speed:
		motion.rotational_motion = controller.max_rotation_speed
	
	return motion