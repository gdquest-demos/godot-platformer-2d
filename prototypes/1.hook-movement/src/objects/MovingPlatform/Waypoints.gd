tool
extends Node2D

enum Mode {CYCLE, PING_PONG}

export(Mode) var mode: = Mode.CYCLE setget set_mode

export var editor_process: = true setget set_editor_process

export var line_color: = Color(0.228943, 0.710254, 0.945312)
export var line_width: = 10.0
export var triangle_color: = Color(0.722656, 0.908997, 1)

var _active_point_index: = 0
var _direction: = 1


func _ready() -> void:
	set_as_toplevel(true)
	if not Engine.editor_hint:
		set_process(false)


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	if not get_child_count() > 1:
		return
	var points: = PoolVector2Array()
	var triangles: = []
	var last_point: = Vector2.ZERO
	for child in get_children():
		assert child is Node2D
		points.append(child.global_position)
		if points.size() > 1:
			var center: Vector2 = (child.global_position + last_point) / 2
			var angle: = last_point.angle_to_point(child.global_position)
			triangles.append({center=center, angle=angle})
		last_point = child.global_position
	
	# Add last segment and arrow if in cycling mode
	if mode == Mode.CYCLE:
		var first_child_position: Vector2 = get_child(0).global_position
		points.append(first_child_position)
		var center: = (first_child_position + last_point) / 2
		var angle: = last_point.angle_to_point(first_child_position)
		triangles.append({center=center, angle=angle})

	draw_polyline(points, line_color, line_width, true)
	for triangle in triangles:
		draw_triangle(triangle['center'], triangle['angle'], line_width * 2.0)


func get_start_position() -> Vector2:
	return get_child(0).global_position


func get_current_point_position() -> Vector2:
	return get_child(_active_point_index).global_position


func get_next_point_position():
	match mode:
		Mode.CYCLE:
			_active_point_index = (_active_point_index + 1) % get_child_count()
		Mode.PING_PONG:
			var index: = _active_point_index + _direction
			if  index < 0 or index > get_child_count() - 1:
				_direction *= -1
			_active_point_index += _direction
	return get_current_point_position()


func draw_triangle(center:Vector2, angle:float, radius:float) -> void:
	var points: = PoolVector2Array()
	var colors: = PoolColorArray([triangle_color])
	for i in range(3):
		var angle_point: = angle + i * 2.0 * PI / 3.0 + PI
		var offset: = Vector2(radius * cos(angle_point), radius * sin(angle_point))
		var point: = center + offset
		points.append(point)
	draw_polygon(points, colors)


func set_editor_process(value:bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_process(value)


func set_mode(value:int) -> void:
	assert value in Mode
	mode = value
