extends State
# State to make enemy fade to nothing, then get released by the scene tree.


export var hurt_color: Color


func enter(msg: Dictionary = {}) -> void:
	owner.body.set_color_fill(hurt_color)
	var animation_player: AnimationPlayer = $AnimationPlayer
	animation_player.play("FadeOut")
	yield(animation_player, "animation_finished")
	owner.queue_free()