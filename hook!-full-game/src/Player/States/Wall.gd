extends State

const WALL_SLIDE_SPEED: = 100.0
const WALL_PULL_STRENGTH: = 300.0

var _jump_strength: = 1000.0
var _velocity: = Vector2.ZERO
var _wall_direction: = -1

func enter(msg: Dictionary = {}) -> void:
	_wall_direction = msg.direction


func physics_process(delta: float) -> void:
	_velocity.y += WALL_SLIDE_SPEED * delta
	_velocity.x += (WALL_PULL_STRENGTH * -_wall_direction) * delta
	_velocity = _player.move_and_slide(_velocity, _player.FLOOR_NORMAL)

	if _player.is_on_floor():
		_state_machine.transition_to("Move/Idle")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		var jump_velocity: = Vector2()
		jump_velocity.x = _wall_direction
		jump_velocity.y = -1.0
		jump_velocity = jump_velocity.normalized() * _jump_strength
		
		_state_machine.transition_to("Move/Air", {"velocity": jump_velocity})
	
	if event.is_action_released("move_left") and _wall_direction > 0:
		_state_machine.transition_to("Move/Air", {"velocity": _velocity.y})
	elif event.is_action_released("move_right") and _wall_direction < 0:
		_state_machine.transition_to("Move/Air", {"velocity": _velocity.y})


func exit() -> void:
	_velocity = Vector2.ZERO
