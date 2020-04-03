# Moving platform, moves to target positions given by the Waypoints node
tool
extends KinematicBody2D

onready var timer: Timer = $Timer
onready var tween: Tween = $Tween
onready var waypoints: = $Waypoints

export var speed: = 400.0
export var wait_time: = 1.0 setget set_wait_time


func _ready() -> void:
	if Engine.editor_hint:
		return
	if not waypoints:
		printerr("Missing Waypoints node for %s: %s" % [name, get_path()])
		return
	position = waypoints.get_start_position()
	timer.start()


func _draw() -> void:
	var shape: = $CollisionShape2D
	var extents: Vector2 = shape.shape.extents * 2.0
	var rect: = Rect2(shape.position - extents / 2.0, extents)
	draw_rect(rect, Color('fff'))


func _on_Timer_timeout() -> void:
	var target_position: Vector2 = waypoints.get_next_point_position()
	var distance_to_target: = position.distance_to(target_position)
	tween.interpolate_property(self, "position", position, target_position, distance_to_target / speed)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	timer.start()


func set_wait_time(value: float) -> void:
	wait_time = value
	if not timer:
		yield(self, "ready")
	timer.wait_time = wait_time
