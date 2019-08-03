tool
extends Area2D


onready var collision_shape: CollisionShape2D = $CollisionShape2D

export(Dictionary) var color: = {
	"active": Color("#fc6767"),
	"inactive": Color("#393939")
}

var is_visited: = false setget set_is_visited


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _draw() -> void:
	draw_circle(collision_shape.position, collision_shape.shape.radius, color.active)


func _on_body_entered(body: PhysicsBody2D) -> void:
	assert body is Player
	self.is_visited = true


func set_is_visited(value: bool) -> void:
	is_visited = value

	if is_visited:
		modulate = color.inactive
		Events.emit_signal("checkpoint_visited", self)
		disconnect("body_entered", self, "_on_body_entered")
