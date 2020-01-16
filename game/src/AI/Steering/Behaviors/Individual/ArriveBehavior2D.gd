extends SteeringBehavior2D
class_name ArriveBehavior2D
# ArriveBehavior2D aims to arrive at where the target is. It follows the
# target and slows down as it gets close to it, within the deceleration_radius.

# # Properties:

# # - `arrival_tolerance` is the distance away from the target that will be good enough to stop moving.
# - `deceleration_radius` is the distance away from the target that the AI should begin weighing down its acceleration
# and slow down.
# - `time_to_target` is a fixed time scale value of time by which it should weigh its velocity by to arrive smoothly.
# This value should be small and defaults to 0.1.

# 

export var arrival_tolerance := 5.0
export var deceleration_radius := 200.0
export var time_to_target := 0.1

var target: Node2D


# Returns the steering motion filled with a linear acceleration amount that will take it towards the target with a
# smooth deceleration, or zero if it is already inside of an arrival threshold.
func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	if not target:
		return steering.reset_values()

	var actor = get_actor()
	var to_target: Vector2 = target.position - actor.position
	var distance := to_target.length()

	if distance <= arrival_tolerance:
		steering.reset_values()
	else:
		var target_speed := controller.max_speed
		if distance <= deceleration_radius:
			target_speed *= distance / deceleration_radius

		var target_velocity := to_target.normalized() * target_speed
		target_velocity = (target_velocity - controller.velocity) * (1.0 / time_to_target)

		steering.velocity = target_velocity.clamped(controller.max_acceleration)
		steering.angular_velocity = 0.0

	return steering
