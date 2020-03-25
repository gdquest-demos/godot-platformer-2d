extends KinematicBody2D
class_name Player


# warning-ignore:unused_signal
signal hopped_off_entity

onready var state_machine: StateMachine = $StateMachine

onready var hook: Position2D = $Hook

onready var skin: Position2D = $Skin
onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider

onready var stats: Stats = $Stats
onready var hitbox: Area2D = $HitBox

onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera

onready var ledge_wall_detector: Position2D = $LedgeWallDetector
onready var floor_detector: RayCast2D = $FloorDetector

onready var pass_through: Area2D = $PassThrough


const FLOOR_NORMAL := Vector2.UP

var is_active := true setget set_is_active
var has_teleported := false
var last_checkpoint: Area2D = null


func _ready() -> void:
# warning-ignore:return_value_discarded
	stats.connect("health_depleted", self, "_on_Player_health_depleted")
# warning-ignore:return_value_discarded
	Events.connect("checkpoint_visited", self, "_on_Events_checkpoint_visited")


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
	ledge_wall_detector.is_active = value
	hitbox.monitoring = value


func get_collider() -> CollisionShape2D:
	return collider


func _on_Player_health_depleted() -> void:
	state_machine.transition_to("Die", {last_checkpoint = last_checkpoint})


func _on_Events_checkpoint_visited(checkpoint_name: String) -> void:
	last_checkpoint = LevelLoader._level.get_node("Checkpoints/%s" % checkpoint_name)
