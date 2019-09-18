extends State
"""
Enemies responding to being grappled with hook with this state.
A stun timer goes off, and their hitbox becomes bounceable instead of damaging.
"""


onready var _timer: Timer = $TimeStunned

export var state_when_struck: String
export var bounciness: = 7500
export var hooked_color: Color
export var hurt_color: Color

var _resume_state: String
var _cached_color: Color


func enter(msg: Dictionary = {}) -> void:
	_resume_state = msg.resume_state
	
	_cached_color = owner.body.color_fill
	owner.body.set_color_fill(hooked_color)
	
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered")
	
	_timer.connect("timeout", self, "_on_state_timeout")
	_timer.start()


func exit() -> void:
	_timer.disconnect("timeout", self, "_on_state_timeout")
	owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")
	owner.body.set_color_fill(_cached_color)


func _on_state_timeout() -> void:
	_state_machine.transition_to(_resume_state)


func _on_Player_body_entered(body: KinematicBody2D) -> void:
	if body.global_position.y < owner.global_position.y:
		body.state_machine.transition_to("Move/Air", { impulse = bounciness })
		owner.body.set_color_fill(hurt_color)
		owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")
		_state_machine.transition_to(state_when_struck, {hurt_color=hurt_color})