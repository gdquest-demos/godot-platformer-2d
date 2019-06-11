"""
Represents an attack or a hit
"""
class_name Hit

var damage = 0

func _init(strength: int, additional_damage: int = 0) -> void:
	damage = strength + additional_damage
