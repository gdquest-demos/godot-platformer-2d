extends Node
class_name SteeringBehavior2D
# The base class for a behavior in 2D space. Subclasses of this class should only
# override `_calculate_steering_internal`.

# # Calling `calculate_steering` on a class that extends this should fill the provided `SteeringMotion2D`
# with an amount of linear and angular acceleration. It is up to the caller to then use that
# information to move the AI actor.


var is_enabled := true
onready var controller: BehaviorController2D = _find_controller(self)


# Returns the motion with the linear and/or angular acceleration filled in, based on the behavior.
func calculate_steering(steering: SteeringMotion2D) -> SteeringMotion2D:
	if not is_enabled or not controller or not controller.has_valid_agent():
		return steering.reset_values()
	else:
		return _calculate_steering_internal(steering)


# Returns the actor upon which the behaviors are acting, to access their position in space.
func get_actor() -> Node2D:
	assert(controller)
	return controller.actor


# Virtual function
# Returns the motion with the linear and/or angular acceleration filled in, based on the behavior.
func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	return steering


# Recursively searches its parent to find the behavior controller that will feed it information.
func _find_controller(current_node: Node) -> Node:
	if not current_node is BehaviorController2D:
		return _find_controller(current_node.get_parent())
	return current_node
