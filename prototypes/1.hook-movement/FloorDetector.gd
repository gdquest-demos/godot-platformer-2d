extends RayCast2D

func is_close_to_floor() -> bool:
	return is_colliding()

func get_floor_position() -> Vector2:
	force_raycast_update()
	if not is_colliding():
		return Vector2.ZERO
	return get_collision_point()
