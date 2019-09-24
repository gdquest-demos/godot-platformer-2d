extends State
"""
Player state when grappling an enemy. Waits to let player aim/take stock, then jumps up.
"""


onready var timer: Timer = $Timer

export var hop_impulse: = 500.0
export var wait_duration: = 0.6


func enter(msg: Dictionary = {}) -> void:
	var timer: = get_tree().create_timer(wait_duration)
	yield(timer, "timeout")
	owner.emit_signal("hopped_off_entity")
	owner.state_machine.transition_to('Move/Air', {impulse = hop_impulse, velocity = Vector2.ZERO})