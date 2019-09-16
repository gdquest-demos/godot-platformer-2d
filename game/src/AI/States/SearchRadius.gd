extends State
"""
State machine state that waits for the player to arrive to initiate a charging attack.
Sets the target position to aim for to the straight line charge behavior.
"""

export var behavior: = NodePath()

onready var _charge: StraightLineBehavior2D = get_node(behavior)

var _target_shape: CollisionShape2D

func physics_process(delta: float) -> void:
	if _target_shape:
		_charge_at_target()


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	_target_shape = body.get_node("CollisionShape2D") as CollisionShape2D


func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	_target_shape = null


func _charge_at_target() -> void:
	#build a straight line that goes through the player shape
	_charge.target = (_target_shape.global_position - _charge.controller.actor.global_position).normalized() * 10000
	_state_machine.transition_to("Charge")