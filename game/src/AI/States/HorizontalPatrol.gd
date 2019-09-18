extends State
"""
State for a simple patroller that goes side to side, changing direction when it bumps into walls.
Responds to player using grappling hook.
"""


export var move_speed: = 200
export var direction: = -1


func enter(msg: Dictionary = {}) -> void:
	owner.hook_target.connect("hooked_onto_from", self, "_on_Hook_hooked_onto_from")
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered")
	owner.hook_target.set_is_active(true)


func exit() -> void:
	owner.hook_target.disconnect("hooked_onto_from", self, "_on_Hook_hooked_onto_from")
	owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")


func physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = owner.move_and_collide(Vector2(direction * move_speed * delta, 0))
	if collision:
		if collision.collider is TileMap:
			direction *= -1


func _on_Hook_hooked_onto_from(hook_position: Vector2) -> void:
	_state_machine.transition_to("Hooked", {resume_state="HorizontalPatrol"})
	

func _on_Player_body_entered(body: PhysicsBody2D) -> void:
	#add with damage to player
	pass