extends Node
class_name StateMachine
"""
Hierarchical State machine for the player.
Initializes states and delegates engine callbacks (_physics_process, _unhandled_input) to the active_state.
"""

onready var active_state: State = $Move/Idle


func setup(player: KinematicBody2D, node: Node = self) -> void:
	for state in node.get_children():
		setup(player, state)
		if state is State:
			state.setup(player, self)


func _unhandled_input(event: InputEvent) -> void:
	active_state.unhandled_input(event)


func _physics_process(delta: float) -> void:
	active_state.physics_process(delta)


func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return

	var target_state: = get_node(target_state_path)
	assert target_state.is_composite == false

	active_state.exit()
	active_state = target_state
	active_state.enter(msg)
	Events.emit_signal("player_state_changed", active_state.name)
