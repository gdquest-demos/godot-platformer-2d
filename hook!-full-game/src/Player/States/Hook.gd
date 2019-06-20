extends State
"""
Moves the player to the target position using the arrive_to steering behavior.
"""


const HOOK_MAX_SPEED: = 1600.0

var target_global_position: = Vector2(INF, INF)
var velocity: = Vector2.ZERO setget set_velocity


func physics_process(delta: float) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	var distance: = to_target.length()
	
	self.velocity = Steering.arrive_to(velocity, owner.global_position, target_global_position, HOOK_MAX_SPEED)
	self.velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	if distance < velocity.length() * delta:
		# Dampen the character's velocity upon reaching the target so it doesn't go flying way above the hook
		# The transition is harsh right now, the arrival behavior may be better
		self.velocity = velocity.normalized() * 400.0
		_state_machine.transition_to("Move/Air", {velocity = velocity})
	Events.emit_signal("player_moved", _player.global_position)


func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v


func exit() -> void:
	target_global_position = Vector2(INF, INF)
	self.velocity = Vector2.ZERO


func set_velocity(value: Vector2) -> void:
	velocity = value
	owner.info_dict.velocity = velocity
