extends Position2D
"""
The player's animated skin. Provides a simple interface to play animations.
"""


signal animation_finished(name)

onready var tween: Tween = $Tween
onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	anim.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func play(name: String, data: ={}) -> void:
	"""
	Plays the requested animation and safeguards against errors
	"""
	anim.stop()
	if name == "ledge":
		assert 'from' in data
		_animate_ledge(data['from'])
	else:
		anim.play(name)


func _animate_ledge(from: Vector2) -> void:
	# Animate the character climbing a ledge from a starting offset
	tween.interpolate_property(
		self, 'position',
		from, Vector2.ZERO, 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	position = from


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if key == ":position":
		emit_signal("animation_finished", "ledge")


func _on_AnimationPlayer_animation_finished(name:String) -> void:
	  emit_signal("animation_finished", name)
