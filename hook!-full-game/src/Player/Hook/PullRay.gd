extends RayCast2D

onready var hook: = $".."
export (float) var pull_strength: = 1000.0

func _ready():
	set_physics_process(false)
	


func _physics_process(delta: float) -> void:
	var cast_direction = hook._get_aim_direction()
	cast_to = cast_direction * hook.length
	if is_colliding():
		pull(get_collider())


func _unhandled_input(event):
	if event.is_action_pressed("hook"):
		set_physics_process(true)
		get_tree().set_input_as_handled()
	elif event.is_action_released("hook"):
		set_physics_process(false)
		get_tree().set_input_as_handled()


func pull(object: RigidBody2D):
	if not object:
		return
	var pulling_direction: Vector2 = (global_position - object.global_position).normalized()
	object.linear_velocity += pulling_direction * (pull_strength * get_physics_process_delta_time())
