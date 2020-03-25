extends State
# Horizontal movement on the ground.
# Delegates movement to its parent Move state and extends it
# with state transitions

onready var slow_starter: Timer = $SlowStarter
onready var tween: Tween = $Tween

export var slow_duration_seconds := 0.4


func _ready() -> void:
# warning-ignore:return_value_discarded
	slow_starter.connect("timeout", self, "_on_SlowDown_timeout")


func _on_SlowDown_timeout() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		_parent,
		"max_speed",
		_parent.max_speed,
		_parent.max_speed_default,
		slow_duration_seconds,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
# warning-ignore:return_value_discarded
	tween.start()


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	if not Utils.is_equal_approx(_parent.max_speed.x, _parent.max_speed_default.x):
		slow_starter.start()


func exit() -> void:
	_parent.exit()
