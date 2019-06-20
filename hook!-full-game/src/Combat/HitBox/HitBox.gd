extends Area2D

onready var collider: CollisionShape2D = $CollisionShape2D

var active: = true setget set_active


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(damage_source: Area2D) -> void:
	var hit: = Hit.new(damage_source)
	owner.take_damage(hit)


func set_active(value: bool) -> void:
	active = value
	collider.disabled = not value
