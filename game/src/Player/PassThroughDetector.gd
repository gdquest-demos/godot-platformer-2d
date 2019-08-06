tool
extends Area2D

onready var _actor: KinematicBody2D = get_node(actor_path)

const PASS_THROUGH_LAYER = 3
export var actor_path: = NodePath("..")


func _ready() -> void:
	connect("body_exited", self, "_on_body_exited")
	if Engine.editor_hint:
		set_physics_process(false)


func _on_body_exited(body: CollisionObject2D) -> void:
	if not _actor.get_collision_mask_bit(PASS_THROUGH_LAYER):
		_actor.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func _physics_process(delta: float) -> void:
	if _actor.is_on_floor() and not _actor.get_collision_mask_bit(PASS_THROUGH_LAYER):
		_actor.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_down") and _actor.is_on_floor():
		_actor.set_collision_mask_bit(PASS_THROUGH_LAYER, false)


func _get_configuration_warning() -> String:
	return "Actor Path must be defined" if actor_path.is_empty() else ""
