extends Area2D


onready var camera_position: Position2D = $CameraPosition


func _ready() -> void:
	return
	connect("area_entered", self, "_on_area", ["entered"])
	connect("area_exited", self, "_on_area", ["exited"])


func _on_area(area: Area2D, which: String) -> void:
	if not area.is_in_group("anchor"):
		return
	
	match which:
		"entered":
			Events.connect("player_moved", self, "_on_Events_player_moved")
		"exited":
			camera_position.position = Vector2.ZERO
			Events.disconnect("player_moved", self, "_on_Events_player_moved")


func _on_Events_player_moved(player_global_position: Vector2) -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("anchor") and area.global_position.x > player_global_position.x:
			camera_position.global_position = area.global_position
