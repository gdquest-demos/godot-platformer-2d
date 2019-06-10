extends "res://src/Player/Skills/Skill.gd"


const DASH_RESET_TIME: = 0.2
const DASH_TIME: = 0.2
const DASH_SPEED: = 2000.0
const TAPPED: = {
	Vector2.LEFT: 0,
	Vector2.RIGHT: 0
}

var transitions: = {
	"air": ["dash"],
	"dash": ["idle", "air"]
}

var _tapped: = TAPPED


func _ready() -> void:
	dependencies["base"] = $"../Base"
	check_dependencies()
	
	Events.connect("player_state_changed", self, "_on_Events_player_state_changed")


func _on_Events_player_state_changed(state: String) -> void:
	if state in ['idle', 'run']:
		_tapped = TAPPED.duplicate()


func _unhandled_input(event: InputEvent) -> void:
	var move_direction: = Vector2.ZERO
	
	if event is InputEventJoypadMotion:
		return
	
	if player._state == "air" and event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		if event.is_action_pressed("move_left"):
			move_direction = Vector2.LEFT
		elif event.is_action_pressed("move_right"):
			move_direction = Vector2.RIGHT
		
		_tapped[move_direction] += 1
		var timer: = get_tree().create_timer(DASH_RESET_TIME)
		timer.connect("timeout", self, 'set', ["_tapped", TAPPED.duplicate()])
	
	for move_direction in _tapped:
		if _tapped[move_direction] == 2:
			_tapped = TAPPED.duplicate()
			
			var timer: = get_tree().create_timer(DASH_TIME)
			timer.connect("timeout", self, 'change_state', [player._state])
			
			change_state("dash")
			player._velocity += move_direction * DASH_SPEED


func exit_state() -> void:
	match player._state:
		"dash":
			player._velocity = player.get_move_direction() * dependencies["base"].max_speed_ground