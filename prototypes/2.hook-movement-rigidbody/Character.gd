extends RigidBody2D

onready var hook: = $Hook

enum {
	IDLE,
	RUN,
	AIR,
	}
var states_strings: = {
	IDLE: "idle",
	RUN: "run",
	AIR: "air",
	}

const FLOOR_NORMAL: = Vector2(0, -1)

var _info_dict: = {} setget _set_info_dict

var _state: int = IDLE
onready var _transitions: = {
		IDLE: [RUN, AIR],
		RUN: [IDLE, AIR],
		AIR: [IDLE],
	}


func _ready() -> void:
	hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")


func _physics_process(delta):
	var move_direction: = get_move_direction()

	# Horizontal movement
	match _state:
		IDLE:
			if move_direction.x:
				change_state(RUN)

		RUN:
			if not move_direction.x:
				change_state(IDLE)

		AIR:
			pass
	

func change_state(target_state:int) -> void:
	if not target_state in _transitions[_state]:
		return
	_state = target_state
	enter_state()
	Events.emit_signal("player_state_changed", states_strings[_state])


func enter_state() -> void:
	match _state:
		IDLE:
			pass
		_:
			return


func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	)


func _set_info_dict(value:Dictionary) -> void:
	_info_dict = value
	Events.emit_signal("player_info_updated", _info_dict)


func _on_Hook_hooked_onto_target(target_position:Vector2) -> void:
	var to_target: = target_position - global_position
	var direction: = to_target.normalized()
	var distance: = to_target.length()
