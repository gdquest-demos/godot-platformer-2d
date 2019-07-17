tool
extends State

onready var jump_delay: Timer = $JumpDelay
onready var fall_delay: Timer = $FallDelay

export var slide_acceleration: = 500.0
export var max_slide_speed: = 400.0
export (float, 0.0, 1.0) var friction_factor: = 0.15

export var jump_strength: = 1000.0
var _velocity: = Vector2.ZERO
var _wall_normal: = -1


func _ready() -> void:
	jump_delay.connect("timeout", self, "_on_JumpDelay_timeout")
	fall_delay.connect("timeout", self, "_on_FallDelay_timeout")


func _get_configuration_warning() -> String:
	return "" if $JumpDelay and $FallDelay else "%s requires two Timer children named JumpDelay and FallDelay" % name


func enter(msg: Dictionary = {}) -> void:
	_wall_normal = msg.normal
	_velocity = msg.velocity
	if _velocity.y < max_slide_speed:
		_velocity.y = 0.0
	
	var wall_detector_length: float = owner.wall_detector.cast_to.length()
	var wall_direction: = -_wall_normal
	owner.wall_detector.cast_to = Vector2(wall_direction * wall_detector_length, 0)
	owner.wall_detector.enabled = true


func physics_process(delta: float) -> void:
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_factor)
	else:
		_velocity.y += slide_acceleration * delta
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	
	if not owner.wall_detector.is_colliding():
		if fall_delay.is_stopped():
			fall_delay.start()
	else:
		fall_delay.stop()


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		var jump_velocity: = Vector2(_wall_normal, -1.0).normalized() * jump_strength
		
		_state_machine.transition_to("Move/Air", {"velocity": jump_velocity})
	
	if (event.is_action_released("move_left") and _wall_normal > 0) or \
	   (event.is_action_released("move_right") and _wall_normal < 0):
		jump_delay.start()


func exit() -> void:
	_velocity = Vector2.ZERO
	owner.wall_detector.enabled = false


func _on_JumpDelay_timeout() -> void:
	_state_machine.transition_to("Move/Air", {"velocity": _velocity.y})


func _on_FallDelay_timeout() -> void:
	_state_machine.transition_to("Move/Air", {"velocity": _velocity.y})
