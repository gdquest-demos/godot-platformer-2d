extends Area2D

signal reached(checkpoint)

export var id := ""

var already_reached := false setget set_already_reached


func _ready() -> void:
	assert not id.empty()
	connect("body_entered", self, "_on_body_entered", [], CONNECT_ONESHOT)


func _on_body_entered(body: PhysicsBody2D) -> void:
	if already_reached or not body is Player:
		return
	self.already_reached = true
	emit_signal("reached", self)


func set_already_reached(value: bool) -> void:
	already_reached = value
	modulate = Color(0.65, 0.65, 0.65) if already_reached else Color(1, 1, 1)
