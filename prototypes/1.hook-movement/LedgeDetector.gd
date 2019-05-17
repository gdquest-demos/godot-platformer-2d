tool
extends Position2D

onready var ray_bottom: = $RayBottom
onready var ray_top: = $RayTop

export var active: = true setget set_active

export var ray_length: = 30.0 setget set_ray_length

var _ray_cast_to_x: float = ray_length setget _set_ray_cast_to_x
var _ready: = false
onready var _offset: float = ray_bottom.position.x

func _ready() -> void:
	_ready = true
	self.ray_length = ray_length


func is_against_ledge(look_direction:int) -> bool:
	if not active:
		return false

	self._ray_cast_to_x = ray_length * look_direction
	ray_bottom.force_raycast_update()
	ray_top.force_raycast_update()
	return ray_bottom.is_colliding() and not ray_top.is_colliding()


func set_ray_length(value:float) -> void:
	if not _ready:
		return
	ray_length = value
	self._ray_cast_to_x = value * sign(_ray_cast_to_x)


func _set_ray_cast_to_x(value:float) -> void:
	_ray_cast_to_x = value
	var cast_to: = Vector2(value, 0.0)
	ray_bottom.cast_to = cast_to
	ray_top.cast_to = cast_to
	ray_bottom.position.x = sign(value) * _offset
	ray_top.position.x = sign(value) * _offset


func set_active(value:bool) -> void:
	active = value
