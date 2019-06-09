extends Node


onready var player: KinematicBody2D = $"../.."
onready var dependencies: Dictionary = {}


func check_dependencies() -> void:
	for key in dependencies:
		if not dependencies[key]:
			queue_free()
			break


func change_state(target_state: String) -> void:
	if not target_state in player._transitions[player._state]:
		return

	exit_state()
	player._state = target_state
	enter_state()
	Events.emit_signal("player_state_changed", player._state)


func enter_state() -> void:
	pass


func exit_state() -> void:
	pass