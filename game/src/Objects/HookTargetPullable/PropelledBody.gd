extends RigidBody2D


func propel(from: Vector2, direction: Vector2) -> void:
	var impulse_strength := 2000.0
	
	mode = MODE_RIGID
	apply_impulse(from, direction * impulse_strength)
	Engine.time_scale = 0.03
	var timer := get_tree().create_timer(0.02)
	yield(timer, "timeout")
	Engine.time_scale = 1.0
