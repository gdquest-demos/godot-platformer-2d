extends Node
class_name BehaviourController2D

export(NodePath) var steering_owner_path: NodePath
export(float) var max_linear_acceleration: float = 10
export(float) var max_speed: float = 10
export(float) var max_rotational_speed: float = 1

var steering_owner: Node2D
var current_linear_velocity: = Vector2()
var current_rotational_velocity: float

func _ready():
	steering_owner = get_node(steering_owner_path) as Node2D