extends Control

onready var reference_node: = get_node(reference_node_path)
onready var container: VBoxContainer = $MarginContainer/VBoxContainer

export (NodePath) var reference_node_path: NodePath = "."
export (PoolStringArray) var properties = []

func _ready() -> void:
	setup_properties()


func _process(delta) -> void:
	for property_string in properties:
		update_property(property_string, reference_node)


func setup_properties() -> void:
	clear_property_labels()
	for property_string in properties:
		add_property_label(property_string)


func clear_property_labels() -> void:
	for property_label in container.get_children():
		property_label.queue_free()

func update_property(property: String, reference_node: Node) -> void:
	var property_label: Label = container.get_node(property.capitalize()) as Label
	property_label.text = "%s %s: %s"%[reference_node.name, property.capitalize(),
			reference_node.get(property)]


func add_property_label(property: String) -> void:
	var label: = Label.new()
	label.name = property.capitalize()
	container.add_child(label)
	update_property(property, reference_node)
