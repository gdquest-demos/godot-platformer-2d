extends Node
class_name BehaviorController2D
"""
Meant to be the parent to behaviors. It is a helper to provide information to its children behaviors.

The controller is the hub through which behaviors access various information about themselves, and
their targets. It holds the maximum speeds and acceleration amounts, and has space to hold current
velocities that can be used in more predictive behaviors. However, the controller is naive and
needs to be fed this information; where the information comes from should be determined by the programmer.
"""

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

"""
Returns true if a Node2D was successfully put into the controller.
"""
func valid() -> bool:
	return steerable != null


"""
Sets the current linear velocity by way of X and Y, rather than copying or creating new vectors.
"""
func set_linear_velocity(x: float, y: float) -> void:
	current_linear_velocity.x = x
	current_linear_velocity.y = y


"""
Sets the target's current linear velocity by way of X and Y, rather than copying or creating new vectors.
Not all behaviors have a target that moves, so match requirements accordingly.
"""
func set_target_linear_velocity(x: float, y: float) -> void:
	target_current_linear_velocity.x = x
	target_current_linear_velocity.y = y