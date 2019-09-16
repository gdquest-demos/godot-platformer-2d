extends State
"""
State machine state to control the charge attack.
Controls the amount of acceleration and speed from the straight line behavior's
desired velocity, and only charges for a set amount of time before moving to cooldown.
"""

export var behavior: = NodePath()
export var charge_time: = 1.0
export var time_to_full_speed = 0.5

onready var _behavior: = get_node(behavior) as StraightLineBehavior2D

var _steering: = SteeringMotion2D.new()
var _elapsed_time: = 0.0

func physics_process(delta: float) -> void:
	_behavior.calculate_steering(_steering)
	var velocity: = _steering.velocity
	
	_elapsed_time += delta
	var speed_proportion: float = clamp(_elapsed_time / time_to_full_speed, 0, 1)
	(_behavior.controller.actor as KinematicBody2D).move_and_slide(velocity * speed_proportion)
	
	if _elapsed_time > charge_time:
		_elapsed_time = 0.0
		_state_machine.transition_to("Cooldown")