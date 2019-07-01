extends Node
class_name BehaviourController2D

export(NodePath) var steerable_path: NodePath
export(float) var max_linear_speed: float
export(float) var max_rotation_speed: float

onready var steerable: Node2D = get_node(steerable_path)

func valid() -> bool:
	return steerable != null