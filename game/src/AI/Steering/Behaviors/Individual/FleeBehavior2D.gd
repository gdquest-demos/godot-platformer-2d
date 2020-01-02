extends SeekBehavior2D
class_name FleeBehavior2D
# FleeBehavior2D is the opposite of Seek. It constantly accelerates away from the target.

func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	._calculate_steering_internal(steering)
	steering.velocity *= -1
	return steering
