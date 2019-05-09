extends Area2D
class_name HookTarget
"""Point the hook can pull onto"""

onready var timer: Timer = $Timer

const COLOR_ACTIVE: Color = Color(0.9375, 0.730906, 0.025635)
const COLOR_INACTIVE: Color = Color(0.515625, 0.484941, 0.4552)

var active: = true setget set_active
var color: = COLOR_ACTIVE setget set_color


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, color)


func set_active(value:bool) -> void:
	active = value
	self.color = COLOR_ACTIVE if active else COLOR_INACTIVE
	timer.start()


func set_color(value:Color) -> void:
	color = value
	update()


func _on_Timer_timeout() -> void:
	self.active = true
