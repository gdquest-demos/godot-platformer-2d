extends State


onready var timer: Timer = $Cooldown
onready var acceleration := Vector2(0, owner.gravity)
onready var move_direction := Vector2(-owner.direction, 1)
onready var jump_vector_right = Vector2(cos(deg2rad(owner.jump_angle_right)), -sin(deg2rad(owner.jump_angle_right)))
onready var jump_vector_left = Vector2(cos(deg2rad(owner.jump_angle_left)), -sin(deg2rad(owner.jump_angle_left)))

var _velocity := Vector2.ZERO
var _jumping := false


func enter(msg: Dictionary = {}) -> void:
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered")
	owner.hook_target.connect("hooked_onto_from", self, "_on_Player_hooked_onto_from", [], CONNECT_ONESHOT)
	timer.connect("timeout", self, "_on_Cooldown_timeout")
	timer.start()


func exit() -> void:
	owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")


func physics_process(delta: float) -> void:
	if not _jumping and owner.is_on_floor():
		return

	_velocity = calculate_velocity(_velocity, acceleration, delta, move_direction)
	owner.move_and_slide(_velocity, Vector2.UP)
	if owner.is_on_floor():
		_jumping = false
		_velocity = Vector2.ZERO
		move_direction.x *= -1
		timer.start()


func _on_Player_body_entered(player: Player) -> void:
	player.take_damage(Hit.new(owner.hitbox))


func _on_Player_hooked_onto_from(hook_position: Vector2) -> void:
	_state_machine.transition_to("Hooked", {hook_position = hook_position})


func _on_Cooldown_timeout() -> void:
	var jump_vector: Vector2 = jump_vector_right if move_direction.x > 0 else jump_vector_left
	var jump_power: float = owner.jump_power_right if move_direction.x > 0 else owner.jump_power_left
	_velocity += calculate_velocity(_velocity, jump_vector * jump_power * Vector2(1,-1), 1.0, jump_vector * move_direction)
	_jumping = true


static func calculate_velocity(old_velocity: Vector2, acceleration: Vector2,
		delta: float, move_direction: Vector2) -> Vector2:
	var new_velocity := old_velocity
	
	new_velocity += move_direction * acceleration * delta
	
	return new_velocity
