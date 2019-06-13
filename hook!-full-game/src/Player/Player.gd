extends KinematicBody2D


onready var hook: Position2D = $Hook
onready var camera: Position2D = $Skin/CameraRig
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var stats: Stats = $Stats
onready var state_machine: Node = $StateMachine

const FLOOR_NORMAL: = Vector2.UP

var info_dict: = {} setget set_info_dict


func _ready() -> void:
	state_machine.setup(self)


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func set_info_dict(value: Dictionary) -> void:
	info_dict = value
	Events.emit_signal("player_info_updated", info_dict)
