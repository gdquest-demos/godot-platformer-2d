extends KinematicBody2D
class_name PullableObject

"""
Used to block the player's way until they pulls this object
"""
onready var gravity: = $Gravity

func _physics_process(delta) -> void:
	check_for_ceiling()


func check_for_ceiling() -> void:
	if is_on_ceiling():
		enable_gravity()


func disable_gravity() -> void:
	gravity.reset()
	gravity.set_physics_process(false)


func enable_gravity() -> void:
	gravity.reset()
	gravity.set_physics_process(true)
