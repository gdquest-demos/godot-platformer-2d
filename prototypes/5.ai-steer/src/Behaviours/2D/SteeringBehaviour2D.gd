extends Node
class_name SteeringBehaviour2D

var enabled: = true

var _controller: BehaviourController2D

func _ready() -> void:
	_get_controller(self)

func calculate_steering() -> SteeringMotion2D:
	if !enabled or _controller == null:
		return SteeringMotion2D.new()
	else:
		return _calculate_steering_internal()


func _calculate_steering_internal() -> SteeringMotion2D:
	return SteeringMotion2D.new()


func _get_controller(current_node: Node) -> void:
	if current_node is BehaviourController2D:
		_controller = current_node
	elif current_node.get_parent() != null:
		_get_controller(current_node.get_parent())