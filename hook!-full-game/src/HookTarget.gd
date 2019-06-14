extends Area2D
class_name HookTarget
"""
Area2D the Hook can hook onto
If one_shot is true, the player can only hook onto the point once
"""


signal hooked_onto_from(hook_position)

export var one_shot: = false

onready var timer: Timer = $Timer

const COLOR_ACTIVE: Color = Color(0.9375, 0.730906, 0.025635)
const COLOR_INACTIVE: Color = Color(0.515625, 0.484941, 0.4552)

var active: = true setget set_active
var color: = COLOR_ACTIVE setget set_color


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, color)


func hooked_from(hook_position: Vector2) -> void:
	self.active = false
	emit_signal("hooked_onto_from", hook_position)


func set_active(value:bool) -> void:
	active = value
	self.color = COLOR_ACTIVE if active else COLOR_INACTIVE

	if not active and not one_shot:
		timer.start()


func set_color(value:Color) -> void:
	color = value
	update()


func _on_Timer_timeout() -> void:
	self.active = true
