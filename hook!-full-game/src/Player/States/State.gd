extends Node


var is_composite: = get_child_count() != 0

var _player: KinematicBody2D = null
var _state_machine: Node = null


func setup(player: KinematicBody2D, state_machine: Node) -> void:
	_player = player
	_state_machine = state_machine
	if _state_machine.active_state == self:
		enter()


func unhandled_input(event: InputEvent) -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func enter(msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass
