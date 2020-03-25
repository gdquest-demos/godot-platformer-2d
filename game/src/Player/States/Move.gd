extends State
# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions

const PASS_THROUGH_LAYER = 3

export var max_speed_default := Vector2(500.0, 1500.0)
export var acceleration_default := Vector2(100000, 3000.0)
export var jump_impulse := 900.0

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO
var snap_distance := 32.0
var snap_vector := Vector2(0, 32)


func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return

	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func _on_Stats_damage_taken():
	_state_machine.transition_to("Stagger")


func _on_PassThrough_body_exited(_body):
	if not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	if event.is_action_pressed('toggle_debug_move'):
		_state_machine.transition_to('Debug')
	
	if event.is_action_pressed("move_down") and owner.is_on_floor():
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, false)
		_state_machine.transition_to("Move/Air")
	elif event.is_action_released("move_down") and not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction())
	velocity = owner.move_and_slide_with_snap(velocity, snap_vector, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)


func enter(_msg: Dictionary = {}) -> void:
	owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	owner.stats.connect("damage_taken", self, "_on_Stats_damage_taken")
	owner.pass_through.connect("body_exited", self, "_on_PassThrough_body_exited")
# warning-ignore:return_value_discarded
	$Air.connect("jumped", $Idle.jump_delay, "start")


func exit() -> void:
	owner.hook.disconnect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	owner.stats.disconnect("damage_taken", self, "_on_Stats_damage_taken")
	owner.pass_through.disconnect("body_exited", self, "_on_PassThrough_body_exited")
	$Air.disconnect("jumped", $Idle.jump_delay, "start")


static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity := old_velocity

	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)
