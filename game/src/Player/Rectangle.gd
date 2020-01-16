tool
extends Node2D
# Draws a rectangle with an outline


export var size := Vector2(40.0, 40.0) setget set_size
export var outline := Vector2(6.0, 6.0) setget set_outline

export var color_fill := Color(0.890625, 0.583793, 0.149597) setget set_color_fill
export var color_outline := Color(0.890625, 0.583793, 0.149597) setget set_color_outline


func _draw() -> void:
	var size_complete := size + outline
	var rect_outline := Rect2(-size_complete / 2, size_complete)
	var rect_fill := Rect2(-size / 2, size)
	draw_rect(rect_outline, color_outline)
	draw_rect(rect_fill, color_fill)


func set_size(value:Vector2) -> void:
	size = value
	update()

func set_outline(value:Vector2) -> void:
	outline = value
	update()


func set_color_fill(value:Color) -> void:
	color_fill = value
	update()


func set_color_outline(value:Color) -> void:
	color_outline = value
	update()
