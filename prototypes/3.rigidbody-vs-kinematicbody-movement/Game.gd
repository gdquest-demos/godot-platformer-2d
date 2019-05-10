extends Node

const PLAYERS := [
	preload("res://player/kinematic/KinematicPlayer.tscn"),
	preload("res://player/rigid/RigidPlayer.tscn")
]

var _player : Node2D
var _player_index := 0


func _ready() -> void:
	_player = _spawn_player()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("switch_player"):
		_player.queue_free()
		_player = _spawn_player()


func _spawn_player() -> Node:
	var player := PLAYERS[_player_index].instance() as Node
	add_child(player)
	player.global_position = Vector2(1920 / 2.0, 1080 / 2.0)
	_player_index = (_player_index + 1) % 2
	return player
