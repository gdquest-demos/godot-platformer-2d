extends State
"""
Lets the player aim and propel themselves from a hooking point
"""


export var launch_power: = 1400.0

func unhandled_input(event: InputEvent) -> void:
	var direction: = Vector2.ZERO

	match Settings.controls:
		Settings.KBD_MOUSE:
			direction = owner.get_local_mouse_position().normalized()
		Settings.GAMEPAD:
			direction = ControlUtils.get_aim_joystick_direction()

	if event.is_action_released("hook"):
		var launch_velocity: = direction * launch_power
		var msg: = {
			velocity = launch_velocity,
			max_speed = launch_velocity.abs()
		}
		_state_machine.transition_to("Move/Air", msg)
