extends Node


var is_composite: = get_child_count() != 0

var _player: KinematicBody2D = null


func ready(player: KinematicBody2D) -> void:
	_player = player
	if _player.active_skill == self:
		enter()


func unhandled_input(event: InputEvent) -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func enter(msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass