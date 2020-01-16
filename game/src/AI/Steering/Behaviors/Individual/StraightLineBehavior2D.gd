extends SteeringBehavior2D
class_name StraightLineBehavior2D
# 2D Behavior that acts like Seek, but for a specific Vector2 position instead of an Object.

export var arrival_tolerance := 5.0

var target: Vector2

func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	var actor = get_actor()
	var to_target: Vector2 = target - actor.position
	var distance := to_target.length()

	if distance <= arrival_tolerance:
		steering.reset_values()
	else:
		steering.velocity = (target - get_actor().position).normalized() * controller.max_acceleration
		steering.angular_velocity = 0
	return steering
