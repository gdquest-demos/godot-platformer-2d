extends Node

export(PackedScene) var StartLevel: = preload("res://src/Levels/Level1.tscn")


func _ready() -> void:
	LevelLoader.setup(self, $Player, StartLevel)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("DEBUG_die"):
		$Player.state_machine.transition_to("Die", {last_checkpoint = $Checkpoints.visited_checkpoints[$Checkpoints.visited_checkpoints.size() - 1]})