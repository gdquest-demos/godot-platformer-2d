extends State
"""
This state is for enemy's response to being grappled with the hook.
They transition to the next state, after boosting player's vertical velocity.
"""


export var state_when_struck: String
export var boost: = 1.5
export var hooked_color: Color

var _resume_state: String
var _cached_color: Color


func enter(msg: Dictionary = {}) -> void:
	_resume_state = msg.resume_state
	
	_cached_color = owner.body.color_fill
	owner.body.set_color_fill(hooked_color)
	
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered")


func exit() -> void:
	owner.hitbox.disconnect("body_entered", self, "_on_Player_body_entered")
	owner.body.set_color_fill(_cached_color)


func _on_Player_body_entered(body: KinematicBody2D) -> void:
	(body as Player).hop_on_enemy()
	_state_machine.transition_to('Destroyed')