extends "res://src/Player/States/State.gd"


const XY_MAX_SPEED: = Vector2(500.0, 1500.0)
const JUMP_SPEED: = 900.0
const ACCELERATION: = Vector2(1e10, 3000.0)

var acceleration: = ACCELERATION
var speed: = XY_MAX_SPEED
var velocity: = Vector2.ZERO setget set_velocity


func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: = target_global_position - _player.global_position
	if _player.is_on_floor() and to_target.y > 0.0:
		return
	
	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func setup(player: KinematicBody2D, state_machine: Node) -> void:
	.setup(player, state_machine)
	_player.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_delay, "start")


func unhandled_input(event: InputEvent) -> void:
	if _player.is_on_floor() and event.is_action_pressed("jump"):
		self.velocity = calculate_velocity(velocity, speed, Vector2(0.0, JUMP_SPEED), 1.0, Vector2.UP)
		_state_machine.transition_to("Move/Air")


func physics_process(delta: float) -> void:
	self.velocity = calculate_velocity(velocity, speed, acceleration, delta, get_move_direction())
	self.velocity = _player.move_and_slide(velocity, _player.FLOOR_NORMAL)


func set_velocity(value: Vector2) -> void:
	if _player == null:
		return
	
	velocity = value
	_player.info_dict.velocity = velocity


static func calculate_velocity(
		old_velocity: Vector2, max_speed: Vector2, acceleration: Vector2,
		delta: float, move_direction: Vector2) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			1.0)
