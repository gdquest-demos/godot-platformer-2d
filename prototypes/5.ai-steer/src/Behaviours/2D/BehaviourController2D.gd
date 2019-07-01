extends Node
class_name BehaviourController2D

export(NodePath) var steerable_path: NodePath
export(float) var max_linear_speed: float
export(float) var max_linear_acceleration: float
export(float) var max_rotation_speed: float
export(float) var max_rotational_acceleration: float

var current_linear_velocity: Vector2 = Vector2()
var current_rotation_velocity: float = 0

var target_current_linear_velocity: Vector2 = Vector2()
var target_current_rotation_velocity: float = 0

onready var steerable: Node2D = get_node(steerable_path)

func valid() -> bool:
	return steerable != null


func set_linear_velocity(x: float, y: float) -> void:
	current_linear_velocity.x = x
	current_linear_velocity.y = y


func set_rotation_velocity(rotational_velocity: float) -> void:
	current_rotation_velocity = rotational_velocity


func set_target_linear_velocity(x: float, y: float) -> void:
	target_current_linear_velocity.x = x
	target_current_linear_velocity.y = y


func set_target_rotation_velocity(rotational_velocity: float) -> void:
	target_current_rotation_velocity = rotational_velocity