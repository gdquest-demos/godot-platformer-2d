extends Area2D
"""Detects and returns the best snapping target for the hook"""

onready var hint: = $HookingHint
onready var ray: RayCast2D = $RayCast2D

var target: HookTarget setget set_target

func _physics_process(delta: float) -> void:
	self.target = find_best_target()


func find_best_target() -> HookTarget:
	force_update_transform()
	var targets: = get_overlapping_areas()
	if not targets:
		target = null
		return null

	var closest_target: HookTarget
	var distance_to_closest: = 100000.0
	for t in targets:
		if not t.active:
			continue
		var distance: = global_position.distance_to(t.global_position)
		if distance > distance_to_closest:
			continue
		ray.global_position = global_position
		ray.cast_to = t.global_position - global_position
		ray.force_update_transform()
		if ray.is_colliding():
			continue
		distance_to_closest = distance
		closest_target = t
	return closest_target


func has_target() -> bool:
	return target != null


func set_target(value:HookTarget) -> void:
	target = value
	hint.visible = target != null
	if target:
		hint.global_position = target.global_position


func _on_Hook_hooked_onto_target(pull_force) -> void:
	if not target:
		return
	target.active = false
	target = null
