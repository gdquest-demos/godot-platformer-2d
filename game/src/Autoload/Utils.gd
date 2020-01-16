extends Node
# Globally accessible utils functionality

# Returns the direction in which the player is aiming with the stick
static func get_aim_joystick_direction() -> Vector2:
	return get_aim_joystick_strength().normalized()


# Returns the strength of the XY input with the joystick used for aiming,
# each axis being a value between 0 and 1
# Adds a circular deadzone, as Godot's built-in system is per-axis,
# creating a rectangular deadzone on the joystick
static func get_aim_joystick_strength() -> Vector2:
	var deadzone_radius := 0.5
	var input_strength := Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	)
	return input_strength if input_strength.length() > deadzone_radius else Vector2.ZERO

# Checks if two numbers are approximately equal
static func is_equal_approx(a: float, b: float, cmp_epsilon: float = 1e-5) -> bool:
	var tolerance := cmp_epsilon * abs(a)
	if tolerance < cmp_epsilon:
		tolerance = cmp_epsilon
	return abs(a - b) < tolerance
