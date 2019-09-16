extends State
"""
Simple state for state machine that waits a set amount of time.
"""

export var cooldown_time: = 3.0

var _elapsed_time: = 0.0

func _physics_process(delta: float) -> void:
	_elapsed_time += delta
	if _elapsed_time > cooldown_time:
		_elapsed_time = 0.0
		_state_machine.transition_to("Search")