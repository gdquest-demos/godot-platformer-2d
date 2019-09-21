extends State


onready var timer: Timer = $Timer

export var hop_impulse: = 500.0
export var wait_duration: = 0.6


func enter(msg: Dictionary = {}) -> void:
	var timer: = get_tree().create_timer(wait_duration)
	yield(timer, "timeout")
	owner.state_machine.transition_to('Move/Air', {impulse = hop_impulse})
