tool
extends Area2D


export(String, FILE) var next_level_file_path: = ""
export(String) var next_level_portal_name: = ""


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _draw() -> void:
	var color: = Color("fb82ff")
	var extents: Vector2 = $CollisionShape2D.shape.extents
	draw_rect(Rect2(Vector2.ZERO - extents, extents * 2), color)


func _get_configuration_warning() -> String:
	return "next_level_file_path is mandatory!" if next_level_file_path.empty() else ""


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player and not body.has_teleported:
		var NextLevel = load(next_level_file_path)
		LevelLoader.trigger(NextLevel, next_level_portal_name)
	body.has_teleported = false
