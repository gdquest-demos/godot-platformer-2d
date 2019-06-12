extends "res://src/Player/SkillsHFSM/Skill.gd"


const XY_MAX_SPEED: = Vector2(500.0, 1500.0)
const JUMP_SPEED: = 900.0
const X_ACCELERATION: = 1e10
const Y_ACCELERATION: = 3000.0

var acceleration: = Vector2(X_ACCELERATION, Y_ACCELERATION)
var speed: = XY_MAX_SPEED
var velocity: = Vector2.ZERO setget set_velocity


func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: = target_global_position - _player.global_position
	if _player.is_on_floor() and to_target.y > 0.0:
		return
	
	_player.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func ready(player: KinematicBody2D) -> void:
	.ready(player)
	_player.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_delay, "start")


func unhandled_input(event: InputEvent) -> void:
	if _player.is_on_floor() and event.is_action_pressed("jump"):
		self.velocity = calculate_jump_velocity(velocity)
		_player.transition_to("Move/Air")


func physics_process(delta: float) -> void:
	self.velocity = calculate_move_velocity(velocity, speed, acceleration, delta, get_move_direction())
	self.velocity = _player.move_and_slide(velocity, _player.FLOOR_NORMAL)


func set_velocity(value: Vector2) -> void:
	if _player == null:
		return
	
	velocity = value
	_player.info_dict.velocity = velocity


static func calculate_move_velocity(
		old_velocity: Vector2, max_speed: Vector2, acceleration: Vector2,
		delta: float, move_direction: Vector2) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	
	return new_velocity


static func calculate_jump_velocity(old_velocity: Vector2) -> Vector2:
	return Vector2(old_velocity.x, old_velocity.y - JUMP_SPEED)


static func get_move_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			1.0)