extends Position2D


signal animation_finished(name)

onready var tween: Tween = $Tween
onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	tween.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func play(name: String, data: ={}) -> void:
	"""
	Plays the requested animation and safeguards against errors
	"""
	anim.stop()
	if name == "ledge":
		assert 'from' in data
		assert 'to' in data
		_animate_ledge(data['from'], data['to'])
	else:
		anim.play(name)


func _animate_ledge(from: Vector2, to: Vector2) -> void:
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


func _on_AnimationPlayer_animation_finished(name:String) -> void:
	  emit_signal("animation_finished", name)

