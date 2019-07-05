extends State


const XY_MAX_SPEED: = Vector2(500.0, 1500.0)
const JUMP_SPEED: = 900.0
const ACCELERATION: = Vector2(1e10, 3000.0)

var acceleration: = ACCELERATION
var speed: = XY_MAX_SPEED
var velocity: = Vector2.ZERO setget set_velocity


func _setup() -> void:
	owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_delay, "start")


func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return

	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func _on_Stats_damage_taken():
	_state_machine.transition_to("Stagger")


func setup(player: KinematicBody2D, state_machine: Node) -> void:
	.setup(player, state_machine)
	owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_delay, "start")
	owner.stats.connect("damage_taken", self, "_on_Stats_damage_taken")


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		if not Input.is_action_pressed("move_down"):
			self.velocity = calculate_velocity(velocity, speed, Vector2(0.0, JUMP_SPEED), 1.0, Vector2.UP)
		_state_machine.transition_to("Move/Air")
	if event.is_action_pressed('toggle_debug_move'):
		_state_machine.transition_to('Debug')


func physics_process(delta: float) -> void:
	self.velocity = calculate_velocity(velocity, speed, acceleration, delta, get_move_direction())
	self.velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)


func set_velocity(value: Vector2) -> void:
	if owner == null:
		return

	velocity = value
	owner.info_dict.velocity = velocity


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
