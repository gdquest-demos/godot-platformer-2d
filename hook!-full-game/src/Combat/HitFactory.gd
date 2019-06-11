"""
Singleton, generates hit objects so entities can take or inflict damage
"""
extends Node

const Hit: = preload('res://src/Combat/Hit.gd')

func generate_hit(source: DamageSource) -> Hit:
	var hit = Hit.new(source.damage)
	return hit
