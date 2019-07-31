extends Node
"""
Saves information about visited checkpoints
"""

var visited_checkpoints := []


func _ready() -> void:
	Events.connect("checkpoint_visited", self, "_on_Events_checkpointed_visited")


func _on_Events_checkpointed_visited(checkpoint: Node2D) -> void:
	visited_checkpoints.append({
		"path": checkpoint.get_path(),
		"checkpoint": checkpoint
	})
