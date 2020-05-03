extends ColorRect

signal faded_to_black

onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_to_black() -> void:
	animation_player.play("fade_in")
	animation_player.queue("fade_in_extras")
	animation_player.queue("loading")


func fade_back_in() -> void:
	animation_player.clear_queue()
	animation_player.play("fade_out")


func _on_AnimationPlayer_animation_changed(old_name: String, new_name: String) -> void:
	if old_name == "fade_in":
		emit_signal("faded_to_black")
