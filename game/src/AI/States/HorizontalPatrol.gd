extends State
# State for a simple patroller that goes side to side, changing direction when it bumps into walls.
# Responds to player using grappling hook.


onready var _move_speed: float = owner.move_speed
onready var _direction: int = owner.direction


func enter(msg: Dictionary = {}) -> void:
	owner.hook_target.connect("hooked_onto_from", self, "_on_Hook_hooked_onto_from", [], CONNECT_ONESHOT)
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered")
	owner.hook_target.is_active = true


func exit() -> void:
	owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")


func physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = owner.move_and_collide(Vector2(_direction * _move_speed * delta, 0))
	if collision and collision.collider is TileMap:
		_direction *= -1


func _on_Hook_hooked_onto_from(hook_position: Vector2) -> void:
	_state_machine.transition_to("Hooked", {hook_position = hook_position})
	

func _on_Player_body_entered(player: Player) -> void:
	player.take_damage(Hit.new(owner.hitbox))