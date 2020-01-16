extends KinematicBody2D

onready var hitbox: Area2D = $Hitbox
onready var hook_target: HookTarget = $HookTarget
onready var collider: CollisionShape2D = $CollisionShape2D
onready var body: Node2D = $Body

export(int, 0, 360, 1) var jump_angle_left := 45
export(int, 0, 360, 1) var jump_angle_right := 45
export var jump_power_left := 500
export var jump_power_right := 500
export(int, -1, 1, 2) var direction := 1
export var gravity := 6000.0
