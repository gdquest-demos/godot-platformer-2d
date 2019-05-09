tool
extends DrawingUtils
"""Draws a target to indicate if and where the player can hook"""

export var color_hook: Color = COLOR_BLUE_LIGHT
export var color_cooldown: Color = COLOR_ERROR

var color: = color_hook setget set_color

func _ready() -> void:
	set_as_toplevel(true)
	update()


func _draw() -> void:
	draw_circle_outline(self, Vector2.ZERO, 20.0, color, 4.0)
	draw_circle(Vector2.ZERO, 10.0, color)


func set_color(value:Color) -> void:
	color = value
	update()
