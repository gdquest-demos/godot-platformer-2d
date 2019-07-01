extends SteeringBehaviour2D
class_name InterceptBehaviour2D
"""
A behaviour that will have the target attempt to predict where the target is headed, and point
its acceleration towards that point.

`max_prediction_time` is how far into the future in fixed time scale the AI will use to predict
the heading of the target.

Supported targets are Node2D and Vector2.
"""

export(float) var max_prediction_time: float

var target

"""
Returns the steering motion filled with a linear acceleration amount that will send it on an
intercept course with wherever the target is headed so that its arrival will cross with the
target's.
"""
func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	if target == null:
		return motion.zero()
	
	var target_position: = _target()
	var distance2: = (target_position - steerable().position).length_squared()
	var speed2: = controller.current_linear_velocity.length_squared()
	
	var prediction_time: = max_prediction_time
	
	if speed2 > 0:
		var prediction_time2 = distance2 / speed2
		if prediction_time2 < max_prediction_time * max_prediction_time:
			prediction_time = sqrt(prediction_time2)
	
	motion.linear_motion = target_position + (controller.target_current_linear_velocity * prediction_time)
	motion.linear_motion = (motion.linear_motion - steerable().position).normalized() * controller.max_linear_acceleration
	motion.rotational_motion = 0
	
	return motion


"""
Returns the target's position.
"""
func _target() -> Vector2:
	if target is Vector2:
		return target
	elif target is Node2D:
		return target.position
	else:
		return steerable().position