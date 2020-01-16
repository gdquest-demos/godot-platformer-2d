# Generates input events continuously based on a timer
# Allows the player to hook onto a target even if they pressed the hook key before the hook was in range
extends Node

export var timer_duration := 0.05

const ACTION_HOOK := 'hook'

var _action_names := []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(ACTION_HOOK) and not ACTION_HOOK in _action_names:
		_action_names.append(ACTION_HOOK)
		_remove_delayed(_action_names.size() - 1, timer_duration)


func _physics_process(delta: float) -> void:
	for action_name in _action_names:
		var event := InputEventAction.new()
		event.action = action_name
		event.pressed = true
		Input.parse_input_event(event)


# Coroutine
func _remove_delayed(action_id:int, delay:float) -> void:
	yield(get_tree().create_timer(delay), "timeout")
	_action_names.remove(action_id)
