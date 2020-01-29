# Represents an attack or a hit
# Created from a DamageSource.
# See DamageSource for more information.
class_name Hit

var damage := 0
var is_instakill := false

func _init(source: DamageSource) -> void:
	damage = source.damage
	is_instakill = source.is_instakill
