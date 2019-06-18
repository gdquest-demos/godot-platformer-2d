tool
extends KinematicBody2D

const ARRIVE_THRESHOLD: = 5.0

onready var floor_detector: RayCast2D = $Pivot/FloorDetector
onready var pivot: Position2D = $Pivot
onready var timer: Timer = $Timer

export var target_distance: = 400.0 setget set_target_distance
export var speed: = 300.0
export var gravity: = 1000.0

onready var waypoints: = {
	start=global_position,
	end=global_position + Vector2(target_distance, 0.0)
}
onready var _target_position: Vector2 = waypoints.end

var _velocity: = Vector2(speed, gravity)


func _ready() -> void:
	timer.connect('timeout', self, '_on_Timer_timeout')
	if Engine.editor_hint:
		update()
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	var steering: = Steering.arrive_to(
						_velocity, 
						global_position,
						_target_position,
						speed)
	_velocity = move_and_slide(_velocity)

	if not floor_detector.is_close_to_floor():
		wait()
	elif global_position.distance_to(_target_position) < ARRIVE_THRESHOLD:
		global_position.x = _target_position.x
		wait()


func wait() -> void:
	set_physics_process(false)
	timer.start()


func walk():
	set_physics_process(true)


func turn() -> void:
	_velocity.x *= -1
	pivot.scale.x *= -1
	_target_position = waypoints.start if _target_position == waypoints.end else waypoints.end


func _on_Timer_timeout() -> void:
	if Engine.editor_hint:
		return
	turn()
	walk()

"""
Draws the path the agent walks in the editor
"""
func _draw() -> void:
	if not Engine.editor_hint:
		return

	var draw_radius: = 20.0
	var line_thickness: = 6.0
	var target: = Vector2(_target_position.x, 0)

	# Path
	draw_line(Vector2.ZERO, target, DrawingUtils.COLOR_BLUE_LIGHT, line_thickness)
	draw_circle(Vector2.ZERO, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)
	draw_circle(target, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)

	# Arrow
	var center: = target / 2
	var angle: = acos(sign(_target_position.x)) + PI
	DrawingUtils.draw_triangle(self, center, angle, draw_radius)


func set_target_distance(value:float) -> void:
	target_distance = value
	if Engine.editor_hint:
		update()
