extends Node
"""
Sample AI controller. It gets and sets the player in its `_ready` function as a target to various
behaviors, and picks whichever one it should be calculating on. It also updates the controller
with information for the behaviors to use. Then, based on what is calculated, it applies
the calculated velocity to itself. Mostly a playground.
"""


onready var _target: Node2D = get_tree().root.get_node('Node2D/Player')
onready var _arrive: ArriveBehavior2D = get_node("BehaviorController2D/PrioritySteering2D/ArriveBehavior2D")
onready var _align: AlignBehavior2D = get_node("BehaviorController2D/PrioritySteering2D/BlendedBehavior2D/AlignBehavior2D")
onready var _flee: FleeBehavior2D = get_node("BehaviorController2D/PrioritySteering2D/BlendedBehavior2D/FleeBehavior2D")
onready var _priority: PrioritySteering2D = get_node("BehaviorController2D/PrioritySteering2D")

onready var _controller: BehaviorController2D = get_node("BehaviorController2D")
onready var _behavior: SteeringBehavior2D = _priority

onready var _last_target_position: Vector2 = _target.position
var _velocity: = Vector2()
var _rotation_velocity: float
var _steering_motion: = SteeringMotion2D.new()


func _ready():
	_arrive.target = _target
	_align.target = _target
	_flee.target = _target


func _process(delta):
	var target_position: = _target.position
	_controller.target_velocity = target_position - _last_target_position
	
	_steering_motion = _behavior.calculate_steering(_steering_motion)
	
	if _steering_motion.motion.length() > 0.0:
		_velocity = (_velocity + _steering_motion.motion).clamped(_controller.max_speed)
		_controller.velocity = _velocity
		
		get_parent().translate(_velocity * delta)
	else:
		_velocity = Vector2.ZERO
		_controller.velocity = _velocity
	
	if _steering_motion.angular_motion > 0.0:
		var _max_rotation_speed_rad = deg2rad(_controller.max_rotation_speed)
		_rotation_velocity = clamp(_rotation_velocity + _steering_motion.angular_steering_motion, -_max_rotation_speed_rad, _max_rotation_speed_rad)
		get_parent().rotate(_rotation_velocity)
	else:
		_rotation_velocity = 0
		_controller.angular_velocity = 0
	
	_last_target_position = target_position