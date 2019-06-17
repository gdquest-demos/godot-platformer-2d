tool
extends DrawingUtils
"""Draws a circle outline to indicate where the player is aiming the hook"""


export var offset: = Vector2(50.0, 0) setget set_offset
export var color: = Color(1, 0.34375, 0.635986) setget set_color

func _draw() -> void:
	draw_circle_outline(self, offset, 8.0, color, 3.0)


func set_color(value:Color) -> void:
	color = value
	update()


func set_offset(value:Vector2) -> void:
	offset = value
	update()
