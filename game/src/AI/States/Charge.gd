extends State
"""
State machine state to control the charge attack.
Controls the amount of acceleration and speed from the straight line behavior's
desired velocity, and only charges for a set amount of time before moving to cooldown.
"""

onready var _behavior: = get_node(behavior) as StraightLineBehavior2D

export var behavior: = NodePath()
export var charge_time: = 1.0
export var time_to_full_speed = 0.5

var _steering: = SteeringMotion2D.new()

func enter(msg: Dictionary = {}) -> void:
	var target_shape: = msg.get("target") as CollisionShape2D
	_behavior.target = (target_shape.global_position - _behavior.controller.actor.global_position).normalized() * 10000
	
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start(charge_time)


func exit() -> void:
	$Timer.disconnect("timeout", self, "_on_Timer_timeout")


func physics_process(delta: float) -> void:
	_behavior.calculate_steering(_steering)
	var velocity: = _steering.velocity
	
	var speed_proportion: float = clamp((charge_time - $Timer.time_left) / time_to_full_speed, 0, 1)
	(_behavior.controller.actor as KinematicBody2D).move_and_slide(velocity * speed_proportion)


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Cooldown")