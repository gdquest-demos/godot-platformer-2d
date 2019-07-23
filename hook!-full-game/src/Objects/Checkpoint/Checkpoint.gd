extends Area2D


var is_visited := false setget set_is_visited


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: PhysicsBody2D) -> void:
	assert body is Player
	self.is_visited = true


func set_is_visited(value: bool) -> void:
	is_visited = value

	if is_visited:
		modulate = Color(0.65, 0.65, 0.65)
		Events.emit_signal("checkpoint_visited", self)
		disconnect("body_entered", self, "_on_body_entered")
