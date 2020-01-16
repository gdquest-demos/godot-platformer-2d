extends Reference
class_name SteeringMotion2D
# Data container for linear and angular steering velocities calculated by behaviors that extend SteeringBehavior2D.


var velocity := Vector2.ZERO
var angular_velocity := 0.0


func reset_values() -> void:
	velocity = Vector2.ZERO
	angular_velocity = 0.0


func is_zero() -> bool:
	return velocity == Vector2.ZERO and angular_velocity == 0.0
