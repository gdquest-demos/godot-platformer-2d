extends State
"""
This state is for enemy's response to being grappled with the hook.
It simply waits until the player body collides with the hitbox, colors the body,
 then transitions to `state_when_struck`
"""


export var state_when_struck: String
export var hooked_color: Color


func enter(msg: Dictionary = {}) -> void:
	owner.body.set_color_fill(hooked_color)
	owner.hitbox.connect("body_entered", self, "_on_Player_body_entered", [], CONNECT_ONESHOT)


func _on_Player_body_entered(body: Player) -> void:
	_state_machine.transition_to(state_when_struck, {player = body})