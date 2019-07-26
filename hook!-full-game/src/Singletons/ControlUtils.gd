"""Globally accessible methods to extend what's available from the Input singleton"""
extends Node


"""
Returns the direction in which the player is aiming with the stick
"""
static func get_aim_joystick_direction() -> Vector2:
	return get_aim_joystick_strength().normalized()


"""
Returns the strength of the XY input with the joystick used for aiming,
each axis being a value between 0 and 1
"""
static func get_aim_joystick_strength() -> Vector2:
	return Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
