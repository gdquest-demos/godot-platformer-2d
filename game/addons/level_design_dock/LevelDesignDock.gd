tool
extends Control

signal packed_scene_button_created(button)
onready var grid_container: GridContainer = $VBoxContainer/GridContainer

const PackedSceneButtonScene := preload("res://addons/level_design_dock/PackedSceneButton.tscn")
const PackedSceneButton := preload("res://addons/level_design_dock/PackedSceneButton.gd")

func drop_data(position: Vector2, data: Dictionary) -> void:
	for packed_scene_path in get_valid_files(data["files"]):
		create_packed_scene_button(packed_scene_path)


func can_drop_data(position: Vector2, data: Dictionary) -> bool:
	var can_drop := false
	if data["type"] == "files":
		can_drop = get_valid_files(data["files"]).size() > 0
	return can_drop


func create_packed_scene_button(packed_scene_path: String) -> void:
	var new_button := PackedSceneButtonScene.instance() as PackedSceneButton
	new_button.packed_scene = load(packed_scene_path)
	new_button.text = packed_scene_path.get_file().trim_suffix(".tscn")
	grid_container.add_child(new_button)
	emit_signal("packed_scene_button_created", new_button)


func get_valid_files(files_list: Array) -> Array:
	var valid_files: Array = []
	for file_path in files_list:
		if file_path.ends_with(".tscn"):
			valid_files.append(file_path)
	return valid_files
