extends Node
class_name BehaviorController2D
# Root node of steering-based AI behaviors. Stores and provides information about its children.

# # BehaviorController2D is the hub through which behaviors access various
# information about themselves, and their targets. It holds the maximum speeds and
# acceleration amounts, and has properties to store velocities that can be used in
# predictive behaviors. BehaviorController2D does not automatically collect this
# information. It is up to the developer to set its properties.


export var actor_path: NodePath
export var max_speed := 400.0
export var max_acceleration := 1000.0
export var max_rotation_speed := 10.0
export var max_angular_acceleration := 10.0

var velocity := Vector2.ZERO
var angular_velocity := 0.0
var target_velocity := Vector2.ZERO
var target_angular_velocity := 0.0

onready var actor: Node2D = get_node(actor_path)


# Returns true if a Node2D was successfully put into the controller.
func has_valid_agent() -> bool:
	return actor != null
