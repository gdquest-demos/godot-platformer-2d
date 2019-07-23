tool
extends Node
"""
Loads and unloads levels
"""

signal loaded(level)

export var LEVEL_START: PackedScene
export var player_path: NodePath

var level: Node
onready var player: Player = get_node(player_path)


func _ready():
	if LEVEL_START:
		setup(LEVEL_START)


func setup(new_level: PackedScene) -> void:
	remove_child(player)
	change_level(new_level)


func change_level(level_new: PackedScene) -> void:
	if level:
		level.queue_free()

	level = level_new.instance()
	add_child(level)
	level.add_child(player)
	emit_signal("loaded", level)


func _get_configuration_warning() -> String:
	var warnings: = PoolStringArray()
	if not LEVEL_START:
		warnings.append("%s is missing a start level, consider setting one in the inspector." % name)
	if not player_path:
		warnings.append("%s is missing the player node as its child" % name)
	return warnings.join("\n")
