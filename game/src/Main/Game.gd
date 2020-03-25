extends Node


onready var transition: ColorRect = $UI/Transition

export(PackedScene) var StartLevel := preload("res://src/Levels/Level1.tscn")

var visited_checkpoints := {}
var level: Node2D = null


func _ready() -> void:
	LevelLoader.setup(self, $Player, StartLevel)
# warning-ignore:return_value_discarded
	Events.connect("checkpoint_visited", self, "_on_Events_checkpoint_visited")


func _on_Events_checkpoint_visited(checkpoint_name: String) -> void:
	visited_checkpoints[level.name] = visited_checkpoints.get(level.name, [])
	visited_checkpoints[level.name].push_back(checkpoint_name)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif event.is_action_pressed("DEBUG_die"):
		var last_checkpoint_name: String = visited_checkpoints[level.name].back()
		var last_checkpoint: Area2D = level.get_node("Checkpoints/" + last_checkpoint_name)
		$Player.state_machine.transition_to("Die", {last_checkpoint = last_checkpoint})
	elif event.is_action_pressed("toggle_full_screen"):
		OS.window_fullscreen = not OS.window_fullscreen
