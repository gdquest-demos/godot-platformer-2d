extends Reference
class_name SteeringMotion2D

var linear_motion: = Vector2()
var rotational_motion: float = 0

func zero() -> void:
	linear_motion.x = 0
	linear_motion.y = 0
	rotational_motion = 0


func is_zero() -> bool:
	return linear_motion.x == 0 and linear_motion.y == 0 and rotational_motion == 0