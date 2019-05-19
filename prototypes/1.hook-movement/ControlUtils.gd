"""Global utility methods to extend what's available from the Input singleton"""
extends Node


static func get_aim_joystick_direction() -> Vector2:
	var use_right_stick: bool = ProjectSettings.get_setting('debug/testing/controls/use_right_stick')
	
	# FIXME: axes should be 2 and 3, or RX and RY, is there a calibration issue with the gamepad?
	if use_right_stick:
		return Vector2(
			Input.get_joy_axis(0, JOY_AXIS_3), 
			Input.get_joy_axis(0, JOY_AXIS_4)).normalized()
	else:
		return Vector2(
			Input.get_joy_axis(0, JOY_AXIS_0), 
			Input.get_joy_axis(0, JOY_AXIS_1)).normalized()
