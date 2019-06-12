extends Node

onready var kinematic_body: = $".."

const FLOOR_NORMAL: = Vector2.UP
export (float) var strength: = 50.0
export (Vector2) var direction = Vector2.DOWN
var _velocity: = Vector2.ZERO

func _physics_process(delta):
	apply()


func apply() -> void:
	if not kinematic_body.is_on_floor():
		print(kinematic_body.name)
		_velocity = kinematic_body.move_and_slide(_velocity, FLOOR_NORMAL)
		_velocity += strength * direction
	else:
		reset()


func reset() -> void:
	_velocity = Vector2.ZERO
