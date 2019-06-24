extends KinematicBody2D


onready var hook: Position2D = $Hook
onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera
onready var area_detector: Area2D = $AnchorDetector
onready var ledge_detector: Position2D = $LedgeDetector
onready var floor_detector: RayCast2D = $FloorDetector
onready var skin: Position2D = $Skin
onready var stats: Stats = $Stats
onready var collider: CollisionShape2D = $CollisionShape2D
onready var hitbox: Area2D = $HitBox

const FLOOR_NORMAL: = Vector2.UP

var is_dead: = false
var is_active: = true setget set_is_active
var info_dict: = {} setget set_info_dict


func _ready() -> void:
	area_detector.connect("area_entered", self, "_on_AreaDetector_area", ["entered"])
	area_detector.connect("area_exited", self, "_on_AreaDetector_area", ["exited"])


func _on_AreaDetector_area(area: Area2D, which: String) -> void:
	if not area.is_in_group("anchor"):
		return
	
	match which:
		"entered":
			camera_rig.is_active = false
			shaking_camera.smoothing_speed = 1.5
		"exited":
			camera_rig.is_active = true
			shaking_camera.smoothing_speed = shaking_camera.default_smoothing_speed


func take_damage(source: Hit) -> void:
	stats.take_damage(source)


func die(respawn: bool = true) -> void:
	camera_rig.is_active = true
	is_dead = true
	skin.play("death")
	yield(skin, "animation_finished")
	if respawn:
		respawn()


func respawn() -> void:
	skin.play("respawn")
	camera_rig.is_active = false
	is_dead = false


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.active = value
	ledge_detector.active = value
	hitbox.monitoring = value


func set_info_dict(value: Dictionary) -> void:
	info_dict = value
	Events.emit_signal("player_info_updated", info_dict)
