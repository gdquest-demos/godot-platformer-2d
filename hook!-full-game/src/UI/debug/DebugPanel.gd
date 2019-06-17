extends Control
"""
Displays the values of properties of a given node
You can directly change the `properties` property to display multiple values from the `reference` node
E.g. properties = PoolStringArray(['speed', 'position', 'modulate'])
"""

onready var _container: VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer
onready var _title: Label = $VBoxContainer/ReferenceName

onready var reference: Node = get_node(reference_path) setget set_reference

export var reference_path: NodePath
export var properties: PoolStringArray setget set_properties


func _process(delta) -> void:
	_update()


func setup() -> void:
	_clear()
	_title.text = reference.name
	for property in properties:
		track(property)


func track(property: String) -> void:
	var label: = Label.new()
	label.autowrap = true
	label.name = property.capitalize()
	_container.add_child(label)
	if not property in properties:
		properties.append(property)


func _clear() -> void:
	for property_label in _container.get_children():
		property_label.queue_free()


func _update() -> void:
	var search_array: Array = properties
	for property in properties:
		var property_label: Label = _container.get_child(search_array.find(property))
		var value = reference.get(property)

		var text: = ""
		if value is Vector2:
			text = "(%01d %01d)" % [value.x, value.y]
		else:
			text = str(value)
		property_label.text = "%s: %s" % [property.capitalize(), text]


func set_properties(value: PoolStringArray) -> void:
	properties = value
	setup()


func set_reference(value: Node) -> void:
	reference = value
	if reference:
	  setup()
