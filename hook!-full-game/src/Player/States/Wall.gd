extends State

onready var jump_delay: Timer = $JumpDelay

export var wall_slide_acceleration: = 100.0
export var max_wall_slide_speed: = 200.0

var _jump_strength: = 1000.0
var _velocity: = Vector2.ZERO
var _wall_normal: = -1


func setup(player: KinematicBody2D, state_machine: Node) -> void:
	.setup(player, state_machine)
	jump_delay.connect("timeout", self, "_on_JumpDelay_timeout")


func enter(msg: Dictionary = {}) -> void:
	_wall_normal = msg.normal
	_velocity = msg.velocity
	if _velocity.y < max_wall_slide_speed:
		_velocity.y = 0.0


func physics_process(delta: float) -> void:
	if _velocity.y > max_wall_slide_speed:
		_velocity.y = lerp(_velocity.y, max_wall_slide_speed, 0.15)
		print("friction")
	else:
		_velocity.y += wall_slide_acceleration * delta
	clamp(_velocity.y, 0.0, max_wall_slide_speed)
	_velocity = _player.move_and_slide(_velocity, _player.FLOOR_NORMAL)

	if _player.is_on_floor():
		_state_machine.transition_to("Move/Idle")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		var jump_velocity: = Vector2(_wall_normal, -1.0).normalized() * _jump_strength
		
		_state_machine.transition_to("Move/Air", {"velocity": jump_velocity})
	
	if ((event.is_action_released("move_left") and _wall_normal > 0) or
			(event.is_action_released("move_right") and _wall_normal < 0)):
		jump_delay.start()


func exit() -> void:
	_velocity = Vector2.ZERO


func _on_JumpDelay_timeout() -> void:
	_state_machine.transition_to("Move/Air", {"velocity": _velocity.y})
