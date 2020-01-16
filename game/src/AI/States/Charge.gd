extends State
# Charge attack in a straight line.
# Controls the amount of acceleration and speed from the straight line behavior's
# desired velocity, and only charges for a set amount of time before moving to cooldown.


onready var _behavior: StraightLineBehavior2D = get_node(behavior)
onready var timer: Timer = $Timer

export var behavior := NodePath()
export var charge_time := 1.0
export var time_to_full_speed = 0.5

var _steering := SteeringMotion2D.new()


func enter(msg: Dictionary = {}) -> void:
	var target: KinematicBody2D = msg.target
	var target_position: Vector2
	if target.has_method("get_collider"):
		var target_shape: CollisionShape2D = target.get_collider()
		target_position = target_shape.global_position
	else:
		 target_position = target.global_position
	
	_behavior.target = (target_position - _behavior.controller.actor.global_position).normalized() * 10000

	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start(charge_time)


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timer_timeout")


func physics_process(delta: float) -> void:
	_behavior.calculate_steering(_steering)
	var velocity := _steering.velocity

	var speed_proportion: float = clamp((charge_time - timer.time_left) / time_to_full_speed, 0, 1)
	(_behavior.controller.actor as KinematicBody2D).move_and_slide(velocity * speed_proportion)


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Cooldown")
