# Stats for the player or the monsters, to manage health, etc.
# Attach an instance of Stats to any object to give it health and stats.
extends Node

class_name Stats

signal health_changed(old_value, new_value)
signal health_depleted()
signal damage_taken()

var modifiers = {}

var invulnerable := false

export var max_health := 1.0 setget set_max_health
var health := max_health

export var attack: int = 1
export var armor: int = 1


func _ready() -> void:
	health = max_health


func take_damage(hit: Hit) -> void:
	if invulnerable:
		return
	
	if hit.is_instakill:
		emit_signal("health_depleted")
		return

	var old_health = health
	health -= hit.damage
	emit_signal("damage_taken")
	health = max(0, health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")


func heal(amount: float) -> void:
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health)


func set_max_health(value: float) -> void:
	if value == null:
		return
	max_health = max(1, value)


func add_modifier(id: int, modifier) -> void:
	modifiers[id] = modifier


func remove_modifier(id: int) -> void:
	modifiers.erase(id)


func set_invulnerable_for_seconds(time: float) -> void:
	invulnerable = true

	var timer := get_tree().create_timer(time)
	yield(timer, "timeout")

	invulnerable = false
