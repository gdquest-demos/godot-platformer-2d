extends Area2D

signal reached(checkpoint)

var already_reached := false


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if already_reached or not body is Player:
		return
	body.checkpoints.append(global_position)
	modulate = Color(0.65, 0.65, 0.65)
	already_reached = true
