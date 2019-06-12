extends CanvasLayer

onready var fade_panel : ColorRect = $FadePanel
onready var vignette : TextureRect = $Vignette
onready var tween : Tween = $Tween


func _ready() -> void:
	Events.connect("player_died", self, "_on_Events_player_died")
	Events.connect("player_respawned", self, "_on_Events_player_respawned")


func _on_Events_player_died() -> void:
	fade_in(Defaults.DEATH_ANIMATION_TIME - Defaults.TRANSITION_TIME)
	vignette_in(0, Defaults.DEATH_ANIMATION_TIME)


func _on_Events_player_respawned() -> void:
	fade_out(0, Defaults.REVIVE_ANIMATION_TIME)


func fade_in(delay: float = 0, time: float = Defaults.TRANSITION_TIME) -> void:
	fade_panel.show()
	fade_panel.modulate = Color(1, 1, 1, 0)
	tween.interpolate_property(fade_panel, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), time,
		Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	tween.start()
	yield(tween, "tween_completed")
	fade_panel.hide()


func fade_out(delay: float = 0, time: float = Defaults.TRANSITION_TIME) -> void:
	fade_panel.show()
	fade_panel.modulate = Color(1, 1, 1, 1)
	tween.interpolate_property(fade_panel, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), time,
		Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	tween.start()
	yield(tween, "tween_completed")
	fade_panel.hide()


func vignette_in(delay: float = 0, time: float = Defaults.TRANSITION_TIME) -> void:
	vignette.show()
	vignette.modulate = Color(1, 1, 1, 0)
	tween.interpolate_property(vignette, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), time,
		Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	tween.start()
	yield(tween, "tween_completed")
	vignette.hide()


func vignette_out(delay: float = 0, time: float = Defaults.TRANSITION_TIME) -> void:
	vignette.show()
	vignette.modulate = Color(1, 1, 1, 1)
	tween.interpolate_property(vignette, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), time,
		Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	tween.start()
	yield(tween, "tween_completed")
	vignette.hide()
