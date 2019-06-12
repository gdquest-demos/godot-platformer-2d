extends RayCast2D

"""
Pulls objects under the Pullable collision layer towards its direction
"""

onready var hook: = $".." as Hook
export (float) var pull_strength: = 400.0

var pull_velocity: = Vector2.ZERO
var _pulling_object: PullableObject = null setget _set_pulling_object

func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	aim()
	check_for_collision()


func _unhandled_input(event: InputEvent) -> void:
	handle_hook_input(event)


func aim() -> void:
	var cast_direction: Vector2 = hook._get_aim_direction()
	cast_to = cast_direction * hook.length


func check_for_collision() -> void:
	if is_colliding():
		if get_collider() is PullableObject:
			_set_pulling_object(get_collider() as PullableObject)
			pull()
	else:
		if _pulling_object:
			release()
		set_physics_process(false)


func handle_hook_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		aim()
		check_for_collision()
		grab()
		set_physics_process(true)
		get_tree().set_input_as_handled()
	elif event.is_action_released("hook"):
		pull_velocity = Vector2.ZERO
		set_physics_process(false)
		release()
		get_tree().set_input_as_handled()


func grab() -> void:
	if not _pulling_object:
		return
	_pulling_object.disable_gravity()


func release() -> void:
	if not _pulling_object:
		return
	_pulling_object.enable_gravity()


func pull() -> void:
	if not _pulling_object:
		return
	var pull_direction: Vector2 = (global_position - _pulling_object.global_position).normalized()
	pull_velocity += pull_direction * (pull_strength * get_physics_process_delta_time())
	pull_velocity = _pulling_object.move_and_slide(pull_velocity, Vector2.UP)


func _set_pulling_object(new_pulling_object: PullableObject):
	if not new_pulling_object:
		return
	if _pulling_object and not new_pulling_object == _pulling_object:
		release()
	_pulling_object = new_pulling_object
