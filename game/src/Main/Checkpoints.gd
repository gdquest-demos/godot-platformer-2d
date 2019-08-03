extends Node
"""
Saves information about visited checkpoints
"""

var visited_checkpoints: = []


func _ready() -> void:
	Events.connect("checkpoint_visited", self, "_on_Events_checkpointed_visited")


func _on_Events_checkpointed_visited(checkpoint: Area2D) -> void:
	assert not checkpoint in visited_checkpoints
	visited_checkpoints.push_back(checkpoint)