extends KinematicBody2D


onready var hook: Position2D = $Hook
onready var camera: Position2D = $CameraRig
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var stats: Stats = $Stats

onready var collider: CollisionShape2D = $CollisionShape2D
onready var hitbox: Area2D = $HitBox

const FLOOR_NORMAL: = Vector2.UP

var active: = true setget set_active
var info_dict: = {} setget set_info_dict

var dead = false


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


func set_active(value: bool) -> void:
	active = value
	if not collider:
		return
	collider.disabled = not value
	hook.active = value
	ledge_detector.active = value
	hitbox.monitoring = value


func set_info_dict(value: Dictionary) -> void:
	info_dict = value
	Events.emit_signal("player_info_updated", info_dict)
