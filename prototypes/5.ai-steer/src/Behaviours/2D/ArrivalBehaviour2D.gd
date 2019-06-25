extends SteeringBehaviour2D
class_name ArrivalBehaviour2D

var target: Node2D
var arrival_tolerance: float = 5
var deceleration_radius: float = 10
var time_to_target: float = 0.1

func _calculate_steering_internal() -> SteeringMotion2D:
	if target == null:
		return SteeringMotion2D.new()
	
	var to_target: = target.position - _controller.steering_owner.position
	var distance: = to_target.length()
	
	if distance <= arrival_tolerance:
		return SteeringMotion2D.new()
	
	var targeted_speed: = _controller.max_speed
	if distance <= deceleration_radius:
		targeted_speed *= distance / deceleration_radius
	
	var target_velocity: = (to_target * (targeted_speed / distance))
	target_velocity -= _controller.current_linear_velocity
	target_velocity *= (1 / time_to_target)
	target_velocity.clamped(_controller.max_linear_acceleration)
	
	var motion: = SteeringMotion2D.new()
	motion.linear_motion = target_velocity
	motion.rotational_motion = 0
		
	return motion