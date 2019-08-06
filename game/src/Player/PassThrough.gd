extends Area2D

const PASS_THROUGH_LAYER = 3

func _ready() -> void:
	connect("body_exited", self, "_on_body_exited")


func _on_body_exited(body: CollisionObject2D) -> void:
	if not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down") and owner.is_on_floor():
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, false)
		owner.state_machine.transition_to("Move/Air")
	if event.is_action_released("move_down") and not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)
