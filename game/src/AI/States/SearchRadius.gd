extends State
# Detects the player entering the search area.
# Sets the target position to aim for to the straight line charge behavior.


func enter(msg: Dictionary = {}) -> void:
	owner.target_detector.connect("body_entered", self, "_on_Area2D_body_entered")
	var overlapping_bodies: Array = owner.target_detector.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		_state_machine.transition_to("Charge", {target=overlapping_bodies[0]})


func exit() -> void:
	owner.target_detector.disconnect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	_state_machine.transition_to("Charge", {target=body})
