tool
extends KinematicBody2D

onready var floor_detector: RayCast2D = $Pivot/FloorDetector
onready var pivot: Position2D = $Pivot

export var target_distance: = 400.0 setget set_target_distance
export var speed: = 300.0
export var gravity: = 1000.0

onready var waypoints: = {
	start=position.x,
	end=position.x + target_distance
}
onready var _target_position: float = waypoints.end 

var draw_radius: = 20.0
var line_thickness: = 6.0


func _ready() -> void:
	if Engine.editor_hint:
		update()
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	var direction: = sign(_target_position - position.x)
	var velocity: = Vector2(speed * direction, gravity)
	move_and_slide(velocity)

	if not floor_detector.is_close_to_floor():
		turn()
	elif sign(_target_position - position.x) != direction:
		position.x = _target_position
		turn()


func turn() -> void:
	_target_position = waypoints.start if _target_position == waypoints.end else waypoints.end
	pivot.scale.x *= -1


func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	var target: = Vector2(_target_position, 0)
	draw_line(Vector2.ZERO, target, DrawingUtils.COLOR_BLUE_LIGHT, line_thickness)
	
	draw_circle(Vector2.ZERO, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)
	draw_circle(target, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)
	
	# Triangle/arrow
	var center: = target / 2
	# FIXME: Why add PI to the angle?
	var angle: = acos(sign(_target_position)) + PI
	DrawingUtils.draw_triangle(self, center, angle, draw_radius)


func set_target_distance(value:float) -> void:
	target_distance = value
	if Engine.editor_hint:
		update()
