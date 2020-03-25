tool
extends Area2D
# Detects and returns the best snapping target for the hook


onready var hooking_hint: Position2D = $HookingHint
onready var ray_cast: RayCast2D = $RayCast2D

var target: HookTarget setget set_target


func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
	ray_cast.set_as_toplevel(true)


func _physics_process(_delta: float) -> void:
	self.target = find_best_target()


# Returns the closest target, skipping targets when there is an obstacle
# between the player and the target.
func find_best_target() -> HookTarget:
	var targets := get_overlapping_areas()

	var closest_target: HookTarget = null
	var distance_to_closest := 100000.0
	for t in targets:
		if not t.is_active:
			continue

		var distance := global_position.distance_to(t.global_position)
		if distance > distance_to_closest:
			continue

		# Skip the target if there is a collider in the way
		ray_cast.global_position = global_position
		ray_cast.cast_to = t.global_position - global_position
		if ray_cast.is_colliding():
			continue

		distance_to_closest = distance
		closest_target = t
	return closest_target


func has_target() -> bool:
	return target != null


# Returns the length of the hook, from the origin to the tip of the collision shape
# Used to draw the hook's radius in the editor
func calculate_length() -> float:
	var length := -1.0
	for collider in [$CapsuleH, $CapsuleV]:
		if not collider:
			continue
		var capsule: CapsuleShape2D = collider.shape
		var capsule_length: float = collider.position.length() + capsule.height / 2 * sin(collider.rotation) + capsule.radius
		length = max(length, capsule_length)
	return length


func set_target(value: HookTarget) -> void:
	target = value
	hooking_hint.visible = target != null
	hooking_hint.global_position = target.global_position if target else hooking_hint.global_position
