tool
extends Position2D

onready var ray_bottom: = $RayBottom
onready var ray_top: = $RayTop

export var ray_length: = 60.0 setget set_ray_length

var look_direction: int = 1
var _ray_cast_to_x: float = ray_length setget _set_ray_cast_to_x


func _physics_process(delta: float) -> void:
	var input_direction: = get_input_direction()
	if input_direction and input_direction != look_direction:
		look_direction = input_direction
		self._ray_cast_to_x = ray_length * look_direction


func is_against_ledge() -> bool:
	ray_bottom.force_raycast_update()
	ray_top.force_raycast_update()
	return ray_bottom.is_colliding() and not ray_top.is_colliding()


func get_input_direction() -> int:
	return int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))


func set_ray_length(value:float) -> void:
	ray_length = value
	self._ray_cast_to_x = value * sign(_ray_cast_to_x)


func _set_ray_cast_to_x(value:float) -> void:
	_ray_cast_to_x = value
	var cast_to: = Vector2(value, 0.0)
	ray_bottom.cast_to = cast_to
	ray_top.cast_to = cast_to
