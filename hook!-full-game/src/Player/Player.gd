extends KinematicBody2D
class_name Player

onready var hook: Position2D = $Hook
onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera
onready var camera_area_detector: Area2D = $CameraAnchorDetector
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var stats: Stats = $Stats
onready var collider: CollisionShape2D = $CollisionShape2D
onready var hitbox: Area2D = $HitBox
onready var wall_detector: RayCast2D = $WallDetector

const FLOOR_NORMAL: = Vector2.UP

var is_active: = true setget set_is_active
var info_dict: = {} setget set_info_dict


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func die(respawn: bool = true) -> void:
	camera_rig.is_active = true
	skin.play("death")
	yield(skin, "animation_finished")
	if respawn:
		respawn()


func respawn() -> void:
	skin.play("respawn")
	camera_rig.is_active = false


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
	ledge_detector.is_active = value
	hitbox.monitoring = value


func set_info_dict(value: Dictionary) -> void:
	info_dict = value
	Events.emit_signal("player_info_updated", info_dict)
