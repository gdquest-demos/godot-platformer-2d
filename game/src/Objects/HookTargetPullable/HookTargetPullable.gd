extends Node2D
# One-shot hook target with an object attached

onready var target: HookTarget = $HookTarget
onready var body: RigidBody2D = $PropelledBody


func _ready() -> void:
	target.connect("hooked_onto_from", self, "_on_HookTarget_hooked_onto_from")


func _on_HookTarget_hooked_onto_from(hook_position: Vector2) -> void:
	var impulse_offset := target.position
	var direction := (hook_position - target.global_position).normalized()
	body.propel(impulse_offset, direction)

