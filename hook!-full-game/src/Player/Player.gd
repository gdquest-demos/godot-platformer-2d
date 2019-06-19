extends KinematicBody2D
class_name Player

onready var hook: Position2D = $Hook
onready var camera: Position2D = $Skin/CameraRig
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var skills: Node = $Skills
onready var stats: Stats = $Stats
onready var animation_player : AnimationPlayer = $AnimationPlayer

var _info_dict: = {} setget _set_info_dict

var _gravity: = 0.0
var _velocity: = Vector2.ZERO

var _state: = "idle"
var checkpoints := []
var dead := false
onready var _transitions: = {}



func _ready() -> void:
	checkpoints.append(global_position)
	animation_player.play("respawn")
	# combine transitions from all skills - union operation on Dictionaries
	for skill in skills.get_children():
		for key in skill.transitions:
			if _transitions.has(key):
				for state in skill.transitions[key]:
					if state in _transitions[key]:
						continue
					
					_transitions[key].push_back(state)
			else:
				_transitions[key] = skill.transitions[key]


func _set_info_dict(value: Dictionary) -> void:
	_info_dict = value
	Events.emit_signal("player_info_updated", _info_dict)


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0.0
	)


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func die(respawn: bool = true) -> void:
	camera.inactive = true
	dead = true
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	if respawn:
		respawn()


func respawn() -> void:
	global_position = checkpoints[checkpoints.size() - 1]
	animation_player.play("respawn")
	camera.inactive = false
	dead = false
