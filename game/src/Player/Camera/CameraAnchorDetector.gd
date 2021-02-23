extends Area2D


onready var camera_position := $CameraPosition


func _ready() -> void:
# warning-ignore:return_value_discarded
	Events.connect("player_moved", self, "_on_Events_player_moved")


func _on_Events_player_moved(player: KinematicBody2D) -> void:
	# first reset parameters
	camera_position.position = Vector2.ZERO
	player.camera_rig.is_active = true
#	player.shaking_camera.reset_smoothing_speed()

	for area in get_overlapping_areas():
		if not area.is_in_group("anchor"):
			continue

		# if needed update player position based on anchor point
		if player.global_position.x < area.global_position.x:
			camera_position.global_position = area.global_position
			player.camera_rig.is_active = false
			player.shaking_camera.smoothing_speed = 1.5
