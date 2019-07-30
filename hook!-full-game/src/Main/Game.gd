extends Node

const StartLevel: PackedScene = preload("res://src/Levels/Level1.tscn")


func _ready() -> void:
	LevelLoader.setup(self, $Player, StartLevel)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
