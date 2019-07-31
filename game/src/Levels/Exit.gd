tool
extends Area2D


export(String, FILE) var next_level_path: = ""


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _draw() -> void:
	var color: = Color("fb82ff")
	var extents: Vector2 = $CollisionShape2D.shape.extents
	draw_rect(Rect2(Vector2.ZERO - extents, extents * 2), color)


func _get_configuration_warning() -> String:
	return "" if next_level_path != "" else "next_level_path needs to be set to the next level"


func _on_body_entered(body: Node) -> void:
	if body is Player:
		var NextLevel = load(next_level_path)
		LevelLoader.trigger(NextLevel)
