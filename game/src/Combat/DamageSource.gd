# Represents a weapon or any entity that can damage others Currently
# barebones, but we can extend this class to add an element like fire, ice, etc.
# Or a status modifier like poison, the chances to apply a given status effect,
# and other metadata that we can later transform into an actual attack. See Hit.gd
extends Area2D

class_name DamageSource

export var damage := 1
export var is_instakill := false
