extends Node2D

onready var animator: = $AnimationPlayer

export (float) var min_playback_speed: float = 1.0
export (float) var max_playback_speed: float = 2.0

func _ready() -> void:
	randomize()
	animator.playback_speed = rand_range(min_playback_speed, max_playback_speed)