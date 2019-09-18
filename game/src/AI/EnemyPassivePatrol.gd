extends KinematicBody2D
"""
A passive enemy; simply patrols side to side and bumps into the player for damage.
Can be hooked onto, and will become damageable.
"""


onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider
onready var hook_target: Area2D = $HookTarget
onready var body: Node2D = $Body
onready var hitbox: Area2D = $Area2D

export var can_be_hooked_stunned: = false


func _ready() -> void:
	if can_be_hooked_stunned:
		hook_target.is_one_shot = false


func get_collider() -> CollisionShape2D:
	return collider