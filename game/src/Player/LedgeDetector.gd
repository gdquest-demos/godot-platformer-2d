tool
extends Position2D
"""
Detects ledges using two Raycasts casting horizontally.
If one ray is in a wall and the other is in the air, it means the node is near a ledge.
"""


onready var ray_bottom: RayCast2D = $RayBottom
onready var ray_top: RayCast2D = $RayTop

export var is_active: = true


func _ready():
	assert ray_top.cast_to.x >= 0
	assert ray_bottom.cast_to.x >= 0


func is_against_ledge(look_direction: int) -> bool:
	if not is_active:
		return false

	scale.x = look_direction
	ray_bottom.force_raycast_update()
	ray_top.force_raycast_update()
	return ray_bottom.is_colliding() and not ray_top.is_colliding()


func get_cast_to_directed() -> Vector2:
	return Vector2(ray_top.cast_to.x * scale.x, 0.0)


func get_top_global_position() -> Vector2:
	return ray_top.global_position


func get_ray_length() -> float:
	return ray_top.cast_to.x
