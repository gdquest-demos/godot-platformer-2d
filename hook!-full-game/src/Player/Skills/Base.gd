extends "res://src/Player/Skills/Skill.gd"


const FLOOR_NORMAL: = Vector2(0, -1)

export var max_speed_ground: = 500.0
export var jump_force: = 900.0

export var gravity_normal: = 3000.0

export var air_acceleration: = 3000.0
export var air_max_speed_normal: float = max_speed_ground
export var air_max_speed_vertical: = Vector2(-1500.0, 1500.0)

var _air_max_speed: = air_max_speed_normal

# Register jump input if the player presses jump before touching the ground
var _air_input_delayed_jump: = false
var _air_input_delayed_jump_duration: = 0.1

# Allow the player to jump right after falling off a ledge
var _idle_input_delayed_jump: = false

var _hook_position: = Vector2.ZERO

var transitions: = {
	"idle": ["run", "air", "hook"],
	"run": ["idle", "air", "hook"],
	"air": ["idle", "ledge", "hook"],
	"hook": ["air", "ledge"],
	"ledge": ["idle"],
}


func _ready() -> void:
	yield(player, "ready")
	player.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	player.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	player._gravity = gravity_normal


# Hook reaction temporarily moved to the player's base skill to make it easier to customize the reaction
# in different prototypes
func _on_Hook_hooked_onto_target(target_position: Vector2) -> void:
	var to_target: = target_position - player.global_position
	if player.is_on_floor() and to_target.y > 0.0:
		return
	_hook_position = target_position
	change_state("hook")


func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge" and player._state == name:
		change_state("idle")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if player._state == "air":
			# Falling from a ledge
			if _idle_input_delayed_jump:
				_idle_input_delayed_jump = false
				_player_jump()
			# End of a fall
			else:
				_air_input_delayed_jump = true
				var timer: = get_tree().create_timer(_air_input_delayed_jump_duration)
				timer.connect("timeout", self, 'set', ['_air_input_delayed_jump', false])
		elif player.is_on_floor():
			_player_jump()


func _physics_process(delta):
	var move_direction: Vector2 = player.get_move_direction()
	# Horizontal movement
	match player._state:
		"idle":
			if move_direction.x:
				change_state("run")
		
		"run":
			if not move_direction.x:
				change_state("idle")
			_player_move(delta, move_direction, max_speed_ground)
		
		"air":
			_player_move(delta, move_direction, _air_max_speed, air_acceleration)
			if player.ledge_detector.is_against_ledge(sign(player._velocity.x)):
				change_state("ledge")
		
		"hook":
			var to_target: = _hook_position - player.global_position
			var distance: = to_target.length()
			
			var hook_max_speed: = 1600.0
			player._velocity = Steering.arrive_to(
									player._velocity,
									player.global_position,
									_hook_position,
									hook_max_speed)
			if distance < player._velocity.length() * delta:
				change_state("air")
	
	# Vertical movement
	if player._state != "ledge":
		player._velocity.y += player._gravity * delta
		player._velocity.y = clamp(player._velocity.y, air_max_speed_vertical.x, air_max_speed_vertical.y)
		var slide_velocity: = player.move_and_slide(player._velocity, FLOOR_NORMAL)
		player._velocity.y = slide_velocity.y
	player._info_dict["velocity"] = player._velocity
	player.camera.update_position(player._velocity)

	# State updates after movement
	if player.is_on_floor() and player._state == "air":
		change_state("idle")
	elif not player.is_on_floor() and player._state in ["idle", "run"]:
		change_state("air")


func _player_move(delta: float, move_direction: Vector2, speed: float, acceleration: float = 0.0) -> void:
	match acceleration:
		0.0:
			player._velocity.x = move_direction.x * speed
		_:
			player._velocity += move_direction * acceleration * delta
			if abs(player._velocity.x) > speed:
				player._velocity.x = sign(player._velocity.x) * speed


func _player_apply(force: Vector2) -> void:
	player._velocity += force


func _player_jump() -> void:
	player._velocity.y -= jump_force


func enter_state() -> void:
	match player._state:
		"idle":
			player._velocity.x = 0.0

			if _air_input_delayed_jump:
				_air_input_delayed_jump = false
				_player_jump()

		"air":
			# Allow the player to jump right after falling off a ledge
			if player._velocity.y >= 0.0:
				_idle_input_delayed_jump = true
				var timer: = get_tree().create_timer(_air_input_delayed_jump_duration)
				timer.connect("timeout", self, 'set', ['_idle_input_delayed_jump', false])

		"hook":
			pass
		
		"ledge":
			# Move the character above the platform, then snap it down to the ground
			var global_position_start: = player.global_position
			player.global_position = player.ledge_detector.ray_top.global_position + Vector2(player.ledge_detector.ray_length * sign(player._velocity.x), 0.0)
			player.global_position = player.floor_detector.get_floor_position()
			player._velocity = Vector2.ZERO
			player.skin.animate_ledge(global_position_start, player.global_position)

		_:
			return


func exit_state() -> void:
	match player._state:
		"air":
			_air_max_speed = air_max_speed_normal
		
		"hook":
			var direction_x: = sign(player._velocity.x)
			if Input.is_action_pressed("move_left") and direction_x == -1 or Input.is_action_pressed("move_right") and direction_x == 1:
				player._velocity.x = direction_x * air_max_speed_normal
