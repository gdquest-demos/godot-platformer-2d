extends KinematicBody2D
class_name Player

onready var state_machine: StateMachine = $StateMachine

onready var hook: Position2D = $Hook

onready var skin: Position2D = $Skin
onready var collider: CollisionShape2D = $CollisionShape2D

onready var stats: Stats = $Stats
onready var hitbox: Area2D = $HitBox

onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera

onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var wall_detector: RayCast2D = $WallDetector


const FLOOR_NORMAL: = Vector2.UP

var is_active: = true setget set_is_active
var has_teleported: = false


func _ready() -> void:
	stats.connect("health_depleted", state_machine, "transition_to", ['Die'])


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
	ledge_detector.is_active = value
	hitbox.monitoring = value
