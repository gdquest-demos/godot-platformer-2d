extends Area2D

signal reached(checkpoint)

var is_unlocked := false


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if is_unlocked or not body is Player:
		return

	body.checkpoints.append(global_position)
	modulate = Color(0.65, 0.65, 0.65)
	is_unlocked = true
