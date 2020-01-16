tool
extends KinematicBody2D
# Simple AI agent to teach game AI programming basics.
# Patrols between two points, stopping at each point to wait for a moment.
# Detects gaps and walls, and turns around instead of getting stuck or falling in holes.


const ARRIVE_THRESHOLD := 3.0

onready var floor_detector: RayCast2D = $Pivot/FloorDetector
onready var pivot: Position2D = $Pivot
onready var timer: Timer = $Timer

export var speed := 300.0
export var gravity := 1000.0

var waypoints := {}
var _target: Vector2

var _velocity := Vector2(0, gravity)


func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
	else:
		timer.connect('timeout', self, '_on_Timer_timeout')
		position = floor_detector.get_floor_position()

	waypoints = {
		start=$Start.global_position,
		end=$End.global_position,
	}
	_target = waypoints.end
	update()


func _physics_process(delta: float) -> void:
	_velocity = Steering.arrive_to(
						_velocity, 
						global_position,
						_target,
						delta,
						speed)
	move_and_slide(_velocity)

	if not floor_detector.is_close_to_floor() or \
		global_position.distance_to(_target) < ARRIVE_THRESHOLD:
		stop()


func stop() -> void:
	set_physics_process(false)
	timer.start()


func walk():
	set_physics_process(true)


func turn() -> void:
	_velocity.x *= -1
	pivot.scale.x *= -1
	_target = waypoints.start if _target == waypoints.end else waypoints.end


func _on_Timer_timeout() -> void:
	if Engine.editor_hint:
		return
	turn()
	walk()


# Draws the path the agent walks in the editor
func _draw() -> void:
	if not Engine.editor_hint or not $Start:
		return

	var draw_radius := 20.0
	var line_thickness := 6.0

	var start: Vector2 = waypoints.start
	var end: Vector2 = waypoints.end

	# Path
	draw_line(start, end, DrawingUtils.COLOR_BLUE_LIGHT, line_thickness)
	draw_circle(start, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)
	draw_circle(end, draw_radius, DrawingUtils.COLOR_BLUE_DEEP)

	# Arrow
	var center := (start + end) / 2
	var angle := start.angle_to(end)
	DrawingUtils.draw_triangle(self, center, angle, draw_radius)

func _get_configuration_warning() -> String:
	var warning := ""
	if not $Start or not $End:
		warning += "%s requires two Position2D children named Start and End to work." % name
	return warning
