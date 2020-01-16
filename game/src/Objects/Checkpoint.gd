extends Area2D


onready var collision_shape: CollisionShape2D = $CollisionShape2D

const COLOR_INACTIVE := Color(1, 1, 1)

var is_visited := false setget set_is_visited


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	
	self.is_visited = true
	
	disconnect("body_entered", self, "_on_body_entered")
	Events.emit_signal("checkpoint_visited", self.name)


func set_is_visited(value: bool) -> void:
	is_visited = value
	if is_visited:
		modulate = COLOR_INACTIVE
