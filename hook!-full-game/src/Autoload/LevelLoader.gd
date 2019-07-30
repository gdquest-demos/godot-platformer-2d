extends Node
"""
Loads and unloads levels
"""

var _game: Node = null
var _player: Player = null
var _level: Node2D = null


func setup(game: Node, player: Player, Level: PackedScene) -> void:
	_game = game
	_player = player
	trigger(Level)


func trigger(NewLevel: PackedScene) -> void:
	_game.remove_child(_player)
	
	if _level:
		_level.queue_free()
		yield(_level, "tree_exited")

	_level = NewLevel.instance()

	var player_spawn: = _level.get_node("Checkpoints").get_child(0)
	_player.global_position = player_spawn.global_position

	_game.add_child(_level)
	_game.add_child(_player)
	
	Events.emit_signal("level_loaded", _level)
