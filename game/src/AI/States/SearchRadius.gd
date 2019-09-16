extends State
"""
State machine state that searches for the player using intersect_shape to
initiate a charging attack. Requires a Circleshape2D resource to set an appropriate radius.
Sets the target position to aim for to the straight line charge behavior.
"""

export(CircleShape2D) var search_shape: CircleShape2D
export var behavior: = NodePath()
export var search_cooldown: = 0.5

onready var _charge: StraightLineBehavior2D = get_node(behavior)

var _space_state: Physics2DDirectSpaceState
var _circle_shape: Physics2DShapeQueryParameters
var _elapsed_time : = search_cooldown

func enter(msg: Dictionary = {}) -> void:
	_space_state = (_state_machine.owner as Node2D).get_world_2d().direct_space_state
	_circle_shape = Physics2DShapeQueryParameters.new()
	_circle_shape.shape_rid = search_shape.get_rid()
	_circle_shape.collision_layer = 1

func physics_process(delta: float) -> void:
	if not _charge:
		return
	
	_elapsed_time += delta
	if _elapsed_time > search_cooldown:
		_elapsed_time = 0
		
		var transform: = Transform2D.IDENTITY.translated(_charge.controller.actor.global_position)
		_circle_shape.set_transform(transform)
		
		var result: = _space_state.intersect_shape(_circle_shape)
		if result:
			for collision in result:
				var collision_shape: = collision.collider.get_node("CollisionShape2D") as CollisionShape2D
				#build a straight line that goes through the player shape
				_charge.target = (collision_shape.global_position - _circle_shape.transform.get_origin()).normalized() * 9999
				_state_machine.transition_to("Charge")
				return