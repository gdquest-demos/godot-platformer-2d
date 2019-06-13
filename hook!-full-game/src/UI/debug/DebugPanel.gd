extends Control

onready var container: VBoxContainer = $MarginContainer/VBoxContainer
onready var reference_node: Node = get_node(reference_node_path)

export (NodePath) var reference_node_path: NodePath
export (PoolStringArray) var properties: PoolStringArray = []

func _ready():
	if reference_node:
		setup()


func _process(delta) -> void:
	for property_string in properties:
		_update(property_string)


func setup() -> void:
	_clear()
	for property_string in properties:
		add_property_label(property_string)


func _clear() -> void:
	for property_label in container.get_children():
		property_label.queue_free()


func add_property_label(property: String) -> void:
	var label: = Label.new()
	label.autowrap = true
	label.name = property.capitalize()
	container.add_child(label)
	if not property in properties:
		properties.append(property)
	_update(property)


func _update(property: String) -> void:
	if not container.has_node(property.capitalize()):
		return
	var search_array: Array = properties
	var property_label: Label = container.get_child(search_array.find(property))
	property_label.text = "%s %s: %s"%[reference_node.name, property.capitalize(),
			reference_node.get(property)]
