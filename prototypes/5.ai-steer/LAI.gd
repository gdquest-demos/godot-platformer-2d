extends Node

var _target: Node2D
var _motion: = SteeringMotion2D.new()

var _controller: BehaviourController2D
var _behaviour: SteeringBehaviour2D
var _arrive: ArriveBehaviour2D
var _seek: SeekBehaviour2D
var _intercept: InterceptBehaviour2D
var _align: AlignBehaviour2D

var _velocity: = Vector2()
var _rotation_velocity: float
var _last_target_position: Vector2

func _ready():
	_target = get_tree().get_nodes_in_group("player")[0]
	
	_arrive = get_node("BehaviourController2D/ArriveBehaviour2D") as ArriveBehaviour2D
	_arrive.target = _target
	
	_seek = get_node("BehaviourController2D/SeekBehaviour2D") as SeekBehaviour2D
	_seek.target = _target
	
	_intercept = get_node("BehaviourController2D/InterceptBehaviour2D") as InterceptBehaviour2D
	_intercept.target = _target
	
	_align = get_node("BehaviourController2D/AlignBehaviour2D") as AlignBehaviour2D
	_align.target = _target
	
	_controller = get_node("BehaviourController2D")
	
	_behaviour = _align
	
	_last_target_position = _target.position


func _process(delta):
	var target_position: = _target.position
	var target_velocity: = target_position - _last_target_position
	_controller.set_target_linear_velocity(target_velocity.x, target_velocity.y)
	
	_behaviour.calculate_steering(_motion)
	if !_motion.is_zero():
		_velocity = (_velocity + _motion.linear_motion).clamped(_controller.max_linear_speed)
		var _max_rotation_speed_rad = deg2rad(_controller.max_rotation_speed)
		_rotation_velocity = clamp(_rotation_velocity + _motion.rotational_motion, -_max_rotation_speed_rad, _max_rotation_speed_rad)
		_controller.set_linear_velocity(_velocity.x, _velocity.y)
		
		get_parent().translate(_velocity * delta)
		get_parent().rotate(_rotation_velocity)
	else:
		_velocity.x = 0
		_velocity.y = 0
		_rotation_velocity = 0
	_last_target_position = target_position