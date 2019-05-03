extends KinematicBody2D

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

export var speed_ground: = 500.0
export var jump_force: = 900.0
export var gravity: = 3000.0

export var air_acceleration: = 3000.0
export var air_max_speed: = 700.0
export var air_max_speed_vertical: = Vector2(-1500.0, 1500.0)

var _velocity: = Vector2.ZERO
var _info_dict: = {} setget _set_info_dict

var _state: int = IDLE
onready var _transitions: = {
		IDLE: [RUN, AIR],
		RUN: [IDLE, AIR],
		AIR: [IDLE],
	}


func _ready() -> void:
	hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		_velocity.y -= jump_force


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
			_velocity.x = move_direction.x * speed_ground

		AIR:
			_velocity.x += air_acceleration * move_direction.x * delta
			if abs(_velocity.x) > air_max_speed:
				_velocity.x = air_max_speed * sign(_velocity.x)
	
	# Vertical movement
	_velocity.y += gravity * delta
	_velocity.y = clamp(_velocity.y, air_max_speed_vertical.x, air_max_speed_vertical.y)
	var slide_velocity: = move_and_slide(_velocity, FLOOR_NORMAL)
	_velocity.y = slide_velocity.y
	self._info_dict["velocity"] = _velocity

	# State updates after movement
	if is_on_floor() and _state == AIR:
		change_state(IDLE)
	if not is_on_floor() and _state in [IDLE, RUN]:
		change_state(AIR)


func change_state(target_state:int) -> void:
	if not target_state in _transitions[_state]:
		return
	_state = target_state
	enter_state()
	Events.emit_signal("player_state_changed", states_strings[_state])


func enter_state() -> void:
	match _state:
		IDLE:
			_velocity.x = 0.0
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


func _on_Hook_hooked_onto_target(force:Vector2) -> void:
	_velocity += force
