"""
Utility functions to manage checkpoints and its file
"""
extends Node

const FILE_PATH := "user://checkpoints.save"

var checkpoints := {
	"visited": [],
	"last_visited_x": 0.0,
	"last_visited_y": 0.0
} 


func _ready() -> void:
	_load_file()
	mark_visited_checkpoints()


func _on_Checkpoint_reached(checkpoint: Node2D) -> void:
	checkpoints.visited.append(checkpoint.id)
	checkpoints.last_visited_x = checkpoint.global_position.x
	checkpoints.last_visited_y = checkpoint.global_position.y
	_save_file()


func _save_file() -> void:
	var checkpoints_file = File.new()
	checkpoints_file.open(FILE_PATH, File.WRITE)
	checkpoints_file.store_line(to_json(checkpoints))
	checkpoints_file.close()


func _load_file() -> void:
	var checkpoints_file = File.new()
	if not checkpoints_file.file_exists(FILE_PATH):
		return
	checkpoints_file.open(FILE_PATH, File.READ)
	while not checkpoints_file.eof_reached():
		var line = JSON.parse(checkpoints_file.get_line()).result
		if line == null:
			continue
		checkpoints = line
	checkpoints_file.close()


func mark_visited_checkpoints() -> void:
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint.id in checkpoints.visited:
			checkpoint.already_reached = true
		else:
			checkpoint.connect("reached", self, "_on_Checkpoint_reached", [], CONNECT_ONESHOT)
