# Gives access to game settings
extends Node

signal controls_changed()


enum { KBD_MOUSE, GAMEPAD }
var controls := KBD_MOUSE setget set_controls

enum AimStick { LEFT=0, RIGHT=1 }
const JOYSTICK_AIM_INPUTS := {
	AimStick.LEFT: {
		'aim_left': {
			axis=JOY_AXIS_0,
			value=-1.0,
		},
		'aim_right': {
			axis=JOY_AXIS_0,
			value=-1.0,
		},
		'aim_up': {
			axis=JOY_AXIS_1,
			value=-1.0,
		},
		'aim_down': {
			axis=JOY_AXIS_1,
			value=1.0,
		},
	},
	AimStick.RIGHT: {
		'aim_left': {
			axis=JOY_AXIS_2,
			value=-1.0,
		},
		'aim_right': {
			axis=JOY_AXIS_2,
			value=-1.0,
		},
		'aim_up': {
			axis=JOY_AXIS_3,
			value=-1.0,
		},
		'aim_down': {
			axis=JOY_AXIS_3,
			value=1.0,
		},
	},
}
var aim_stick: int = 0 setget set_aim_stick


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if controls == KBD_MOUSE:
			self.controls = GAMEPAD
	elif event is InputEventMouse and controls == GAMEPAD:
			self.controls = KBD_MOUSE


func set_controls(value: int) -> void:
	controls = value
	emit_signal("controls_changed")


# Switch between using the gamepad's left and right joystick
# to aim the hook.
# Replaces the Input map actions
func set_aim_stick(value: int) -> void:
	assert(value in [AimStick.LEFT, AimStick.RIGHT])
	var setting: int = ProjectSettings.get_setting('debug/testing/controls/aim_stick')
	if value == setting:
		return

	aim_stick = value
	ProjectSettings.set_setting('debug/testing/controls/aim_stick', value)

	var action_suffixes := ['left', 'right', 'up', 'down']
	for suffix in action_suffixes:
		var action_name: String = 'aim_' + suffix
		InputMap.action_erase_events(action_name)
		var event := get_joypad_motion_event(action_name, aim_stick)
		InputMap.action_add_event(action_name, event)
		print(action_name)


# Returns a new InputEventJoypadMotion event for aim_* input events,
# using JOYSTICK_AIM_INPUTS for the base data 
# Use AimStick.* for the stick argument
func get_joypad_motion_event(action: String, stick: int) -> InputEventJoypadMotion:
	var event := InputEventJoypadMotion.new()
	var action_data: Dictionary = JOYSTICK_AIM_INPUTS[stick][action]
	action_data.deadzone = 0.0
	event.axis = action_data.axis
	event.axis_value = action_data.value
	return event
