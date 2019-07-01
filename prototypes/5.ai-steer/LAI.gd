extends Node

var _target: Node2D

func _ready():
	_target = get_tree().get_nodes_in_group("player")[0]


func _process(delta):
	pass