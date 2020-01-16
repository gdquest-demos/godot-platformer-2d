tool
extends EditorPlugin

const LevelDesignDockScene := preload("res://addons/level_design_dock/LevelDesignDock.tscn")
const LevelDesignDock := preload("res://addons/level_design_dock/LevelDesignDock.gd")
const PackedSceneButton := preload("res://addons/level_design_dock/PackedSceneButton.gd")

var _interface: LevelDesignDock
var _current_instance: Node2D setget _set_current_instance
var _current_parent: Node setget _set_current_parent
var _current_scene: PackedScene setget _set_current_scene

func _enter_tree() -> void:
	_interface = LevelDesignDockScene.instance()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UR, _interface)
	_interface.connect("packed_scene_button_created", self, "_on_Interface_PackedScene_Button_Created")


func _exit_tree() -> void:
	_interface.queue_free()


func handles(object: Object) -> bool:
	var can_handle = object is Node
	if can_handle:
		self._current_parent = object
	return can_handle


func forward_canvas_gui_input(event: InputEvent) -> bool:
	var forward := false
	if event is InputEventMouseMotion:
		_move_instance()
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			forward = true
			if event.is_pressed():
				_create_instance()
			else:
				_current_instance = null
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			_current_instance = null
			_current_parent = null
			_current_scene = null
			forward = true
	return forward


func _move_instance() -> void:
	var can_drag = Input.is_mouse_button_pressed(BUTTON_LEFT) and _current_instance
	if can_drag:
		_current_instance.global_position = _current_instance.get_global_mouse_position()


func _on_Interface_PackedScene_Button_Created(button: PackedSceneButton) -> void:
	button.connect("toggled", self, "_on_PackedSceneButton_button_toggled", [button])


func _on_PackedSceneButton_button_toggled(button_pressed: bool, button: PackedSceneButton):
	if button_pressed:
		self._current_scene = button.packed_scene
	else:
		_current_scene = null


func _can_instance() -> bool:
	return _current_parent and _current_scene


func _create_instance() -> void:
	if not _can_instance():
		return
	get_editor_interface().get_selection().clear()
	var instance = _current_scene.instance()
	var undo = get_undo_redo()
	self._current_instance = instance
	
	undo.create_action("Add child")
	undo.add_do_method(_current_parent, "add_child", instance)
	undo.add_undo_method(_current_parent, "remove_child", instance)
	undo.commit_action()
	instance.owner = get_editor_interface().get_edited_scene_root()


func _set_current_instance(new_instance: Node2D) -> void:
	_current_instance = new_instance


func _set_current_scene(new_packed_scene: PackedScene) -> void:
	_current_scene = new_packed_scene


func _set_current_parent(new_parent: Node) -> void:
	_current_parent = new_parent
