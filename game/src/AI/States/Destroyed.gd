extends State
"""
State to make enemy fade to nothing, then get released by the scene tree.
"""


export var hurt_color: Color


func enter(msg: Dictionary = {}) -> void:
	owner.hook_target.set_color(Color(0, 0, 0, 0))
	owner.body.set_color_fill(hurt_color)
	
	yield(do_color(), "completed")
	
	owner.queue_free()


func do_color() -> void:
	var start_fill_color: Color = owner.body.color_fill
	var start_outline_color: Color = owner.body.color_outline
	
	for i in range(0, 30):
		start_fill_color.a = lerp(1, 0, i / 30.0)
		start_outline_color.a = lerp(1, 0, i / 30.0)
		
		owner.body.set_color_fill(start_fill_color)
		owner.body.set_color_outline(start_outline_color)
		
		yield(get_tree(), "idle_frame")