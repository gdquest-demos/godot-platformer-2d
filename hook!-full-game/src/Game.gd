extends Node

onready var player : Player = $Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		player.die()
