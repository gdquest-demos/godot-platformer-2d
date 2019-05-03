extends Node2D

onready var head: = $Head
onready var tail: = $Tail
onready var tween: Tween = $Tween

var hook_position: = Vector2.ZERO setget set_hook_position
var length: = 40.0 setget set_length

onready var start_length: float = head.position.x

func set_hook_position(value:Vector2) -> void:
	hook_position = value
	var to_target: = hook_position - global_position
	self.length = to_target.length()
	rotation = to_target.angle()
	tween.interpolate_property(
		self, 'length', length, start_length, 
		0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	visible = true


func set_length(value: float) -> void:
	length = value
	tail.points[-1].x = length
	head.position.x = tail.points[-1].x + tail.position.x


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	visible = false
