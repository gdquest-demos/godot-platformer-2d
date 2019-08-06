tool
extends State
"""
Handles wall movement: sliding against the wall and wall jump
"""


export var slide_acceleration: = 1600.0
export var max_slide_speed: = 400.0
export (float, 0.0, 1.0) var friction_factor: = 0.15

export var jump_strength: = Vector2(500.0, 400.0)
var _wall_normal: = -1
var _velocity: = Vector2.ZERO


func enter(msg: Dictionary = {}) -> void:
	_wall_normal = msg.normal
	_velocity.y = clamp(msg.velocity.y, -max_slide_speed, max_slide_speed)

	owner.wall_detector.cast_to.x = abs(owner.wall_detector.cast_to.x) * -1.0 * sign(_wall_normal)
	owner.wall_detector.enabled = true


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()


func physics_process(delta: float) -> void:
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_factor)
	else:
		_velocity.y += slide_acceleration * delta
	_velocity.y = clamp(_velocity.y, -max_slide_speed, max_slide_speed)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")

	var move: = get_parent()
	var is_moving_away_from_wall: = sign(move.get_move_direction().x) == sign(_wall_normal)
	if is_moving_away_from_wall:
		_state_machine.transition_to("Move/Air")


func exit() -> void:
	owner.wall_detector.enabled = false


func jump() -> void:
	# The direction vector not being normalized is intended
	var impulse: = Vector2(_wall_normal, -1.0) * jump_strength
	var msg: = {
		velocity = impulse,
		wall_jump = true
	}
	_state_machine.transition_to("Move/Air", msg)
