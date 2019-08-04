extends State
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""


export var max_speed_default: = Vector2(500.0, 1500.0)
export var acceleration_default: = Vector2(100000, 3000.0)
export var jump_impulse: = 900.0

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO


func _setup() -> void:
	owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_delay, "start")
	owner.stats.connect("damage_taken", self, "_on_Stats_damage_taken")


func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return

	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func _on_Stats_damage_taken():
	_state_machine.transition_to("Stagger")


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	if event.is_action_pressed('toggle_debug_move'):
		_state_machine.transition_to('Debug')


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction())
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)


static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity

	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)
