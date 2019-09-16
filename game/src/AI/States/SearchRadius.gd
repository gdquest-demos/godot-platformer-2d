extends State
"""
State machine state that waits for the player to arrive to initiate a charging attack.
Sets the target position to aim for to the straight line charge behavior.
"""

func enter(msg: Dictionary = {}) -> void:
	$"../../SearchRadius".connect("body_entered", self, "_on_Area2D_body_entered")
	var bodies: = $"../../SearchRadius".get_overlapping_bodies() as Array
	if bodies.size() > 0:
		_change_state(bodies[0].get_node("CollisionShape2D"))


func exit() -> void:
	$"../../SearchRadius".disconnect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	_change_state(body.get_node("CollisionShape2D"))


func _change_state(target_shape: CollisionShape2D) -> void:
	_state_machine.transition_to("Charge", {target=target_shape})