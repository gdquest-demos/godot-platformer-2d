extends Area2D


var is_visited := false


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if is_visited or not body is Player:
		return

	modulate = Color(0.65, 0.65, 0.65)
	is_visited = true
	Events.emit_signal("checkpoint_visited", self)
