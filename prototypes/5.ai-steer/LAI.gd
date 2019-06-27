extends Node

var _target: Node2D
var _seek: SeekBehaviour2D

func _ready():
	_target = get_node("../../Player")
	_seek = get_node("../BehaviourController2D/SeekBehaviour2D")
	_seek.target = _target

func _process(delta):
	var result: = _seek.calculate_steering()
	get_parent().position += result.linear_motion
	get_parent().rotation += result.rotational_motion