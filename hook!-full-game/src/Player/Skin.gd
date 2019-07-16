extends Position2D
"""
The player's animated skin. Provides a simple interface to play animations.
"""

signal animation_finished(name)

onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim.connect("animation_finished", self, "_on_Anim_animation_finished")


func _on_Anim_animation_finished(name: String) -> void:
	emit_signal("animation_finished", name)


func play(name: String, data: Dictionary = {}) -> void:
	"""
	Plays the requested animation and safeguards against errors
	"""
	assert name in anim.get_animation_list()
	anim.stop()
	if name == "ledge":
		assert 'from' in data
		position = data.from
	anim.play(name)
