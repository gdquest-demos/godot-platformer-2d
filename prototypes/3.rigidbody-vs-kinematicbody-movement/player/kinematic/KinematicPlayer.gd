extends KinematicBody2D

onready var _transitions := {
		IDLE: [RUN, AIR],
		RUN: [IDLE, AIR],
		AIR: [IDLE, LEDGE],
		LEDGE: [IDLE],
	}

const FLOOR_NORMAL := Vector2.UP

enum {
	IDLE,
	RUN,
	AIR,
	LEDGE
}

export var speed_ground := 500.0
export var jump_force := 900.0
export var gravity := 3000.0

export var air_acceleration := 3000.0
export var air_max_speed := 700.0

var _velocity := Vector2.ZERO
var _state : int = IDLE

var states_strings := {
	IDLE: "idle",
	RUN: "run",
	AIR: "air",
	LEDGE: "ledge",
}


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		_velocity.y -= jump_force


func _physics_process(delta: float) -> void:
	var move_direction := get_move_direction()

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
	
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	# State updates after movement
	if is_on_floor() and _state == AIR:
		change_state(IDLE)
	if not is_on_floor() and _state in [IDLE, RUN]:
		change_state(AIR)


func change_state(target_state: int) -> void:
	if not target_state in _transitions[_state]:
		return
	_state = target_state
	enter_state()


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
