extends Node
class_name SteeringBehaviour2D

var enabled: = true
var controller: BehaviourController2D

func _ready() -> void:
	_get_controller(self)


func calculate_steering(motion: SteeringMotion2D) -> SteeringMotion2D:
	if !enabled or controller == null or !controller.valid():
		return motion.zero()
	else:
		return _calculate_steering_internal(motion)


func steerable() -> Node2D:
	if controller == null:
		return null
	return controller.steerable


func _calculate_steering_internal(motion: SteeringMotion2D) -> SteeringMotion2D:
	return motion


func _get_controller(current_node: Node) -> void:
	if current_node is BehaviourController2D:
		controller = current_node
	elif current_node.get_parent() != null:
		_get_controller(current_node.get_parent())