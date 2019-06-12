extends Node


const Skill: = preload("res://src/Player/SkillsHFSM/Skill.gd")


func ready(player: KinematicBody2D, node: Node = self) -> void:
	for skill in node.get_children():
		ready(player, skill)
		if skill is Skill:
			skill.ready(player)