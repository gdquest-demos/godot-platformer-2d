extends Position2D
# The player's animated skin. Provides a simple interface to play animations.

signal animation_finished(name)

onready var anim: AnimationPlayer = $AnimationPlayer
onready var floor_detector: FloorDetector = $FloorDetector
onready var shadow: Sprite = $Shadow


func _ready() -> void:
# warning-ignore:return_value_discarded
	anim.connect("animation_finished", self, "_on_Anim_animation_finished")


func _on_Anim_animation_finished(name: String) -> void:
	emit_signal("animation_finished", name)


func _physics_process(_delta: float) -> void:
	floor_detector.force_raycast_update()
	shadow.visible = floor_detector.is_close_to_floor()
	var ratio := floor_detector.get_floor_distance_ratio()
	shadow.scale = Vector2(ratio, ratio) * shadow.scale_start
	shadow.global_position = floor_detector.get_floor_position()


func play(name: String, data: Dictionary = {}) -> void:
	# Plays the requested animation and safeguards against errors
	assert(name in anim.get_animation_list())
	anim.stop()
	if name == "ledge":
		assert('from' in data)
		position = data.from
	anim.play(name)

