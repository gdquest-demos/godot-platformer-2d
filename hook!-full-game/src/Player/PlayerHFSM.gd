extends KinematicBody2D


onready var hook: Position2D = $Hook
onready var camera: Position2D = $Skin/CameraRig
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var stats: Stats = $Stats
onready var skills: Node = $Skills
onready var active_skill: Node = skills.get_node("Move/Idle")

const FLOOR_NORMAL: = Vector2.UP

var info_dict: = {} setget set_info_dict


func _ready() -> void:
	skills.ready(self)


func _unhandled_input(event: InputEvent) -> void:
	active_skill.unhandled_input(event)


func _physics_process(delta: float) -> void:
	active_skill.physics_process(delta)


func set_info_dict(value: Dictionary) -> void:
	info_dict = value
	Events.emit_signal("player_info_updated", info_dict)


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func transition_to(target_skill_path: String, msg: Dictionary = {}) -> void:
	if not skills.has_node(target_skill_path):
		return
	
	var target_skill: = skills.get_node(target_skill_path)
	assert target_skill.is_composite == false
	
	active_skill.exit()
	active_skill = target_skill
	active_skill.enter(msg)
	Events.emit_signal("player_skill_changed", active_skill.name)