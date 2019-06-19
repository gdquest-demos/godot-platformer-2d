extends Node
class_name StateMachine
"""
Hierarchical State machine for the player.
Initializes states and delegates engine callbacks (_physics_process, _unhandled_input) to the active_state.
"""


export(NodePath) var initial_state

onready var active_state: State = get_node(initial_state)


func _init() -> void:
	add_to_group("hfsm")


func _ready() -> void:
	active_state.enter()


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
