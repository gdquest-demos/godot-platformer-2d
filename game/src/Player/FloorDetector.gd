extends RayCast2D
class_name FloorDetector
# Down facing ray, relative to its parent, used to detect the floor and the floor's position.


func is_close_to_floor() -> bool:
	return is_colliding()


func get_floor_position() -> Vector2:
	force_raycast_update()
	return get_collision_point()


func get_floor_distance_ratio() -> float:
	force_raycast_update()
	var ratio := 1.0 - abs(get_collision_point().y - global_position.y) / cast_to.y
	return ratio
