extends RayCast2D
"""
Down facing ray, relative to its parent, used to detect the floor and the floor's position.
"""


func is_close_to_floor() -> bool:
	return is_colliding()


func get_floor_position() -> Vector2:
	force_raycast_update()
	return get_collision_point()
