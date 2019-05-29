extends Area2D

signal player_fell

func _ready():
	connect("body_exited", self, "_on_body_exited")


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_fell")
