extends Node
class_name BehaviourController2D

export(NodePath) var steering_owner_path: NodePath
export(float) var max_linear_acceleration: float = 10
export(float) var max_speed: float = 10
export(float) var max_rotational_speed: float = 1

var steering_owner: Node2D
var current_linear_velocity: = Vector2()
var current_rotational_velocity: float

var _last_position: Vector2
var _last_rotation: float

func _ready():
	steering_owner = get_node(steering_owner_path) as Node2D
	if steering_owner:
		_last_position = steering_owner.position
		_last_rotation = steering_owner.rotation

func _process(delta):
	if !steering_owner:
		return
	var position: = steering_owner.position as Vector2
	var to_current: = position - _last_position
	current_linear_velocity = to_current
	var rotation: = steering_owner.rotation as float
	current_rotational_velocity = rotation - _last_rotation
	_last_position = position
	_last_rotation = rotation