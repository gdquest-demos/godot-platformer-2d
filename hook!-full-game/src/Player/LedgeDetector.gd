tool
extends Position2D
"""
Detects ledges using two Raycasts casting horizontally.
If one ray is in a wall and the other is in the air, it means the node is near a ledge.
"""

onready var ray_bottom: RayCast2D = $RayBottom
onready var ray_top: RayCast2D = $RayTop

onready var _offset: float = ray_bottom.position.x

export var is_active: = true setget set_is_active

export var ray_length: = 30.0 setget set_ray_length

var _ray_cast_to_x: = ray_length setget _set_ray_cast_to_x
var _is_ready: = false


func _ready() -> void:
	_is_ready = true
	self.ray_length = ray_length


func is_against_ledge(look_direction: int) -> bool:
	if not is_active:
		return false

	self._ray_cast_to_x = ray_length * look_direction
	ray_bottom.force_raycast_update()
	ray_top.force_raycast_update()
	return ray_bottom.is_colliding() and not ray_top.is_colliding()


func set_ray_length(value: float) -> void:
	if not _is_ready:
		return
	
	ray_length = value
	self._ray_cast_to_x = value * sign(_ray_cast_to_x)


func set_is_active(value:bool) -> void:
	is_active = value


func _set_ray_cast_to_x(value: float) -> void:
	_ray_cast_to_x = value
	var cast_to: = Vector2(value, 0.0)
	ray_bottom.cast_to = cast_to
	ray_top.cast_to = cast_to
	ray_bottom.position.x = sign(value) * _offset
	ray_top.position.x = sign(value) * _offset
