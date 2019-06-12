extends Position2D


signal animation_finished(name)

onready var tween: Tween = $Tween


func _ready() -> void:
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")


func animate_ledge(from: Vector2, to: Vector2) -> void:
	# Animate the character climbing a ledge between two positions
	# To replace with an interpolate method, to control X and Y axes?
	tween.interpolate_property(
			self, 'global_position',
			from, to, 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if key == ":global_position":
		emit_signal("animation_finished", "ledge")
