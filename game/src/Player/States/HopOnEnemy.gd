extends State
# Player state when grappling an enemy. Waits to let player aim/take stock, then jumps up.


export var hop_impulse := 500.0
export var wait_duration := 0.6


func enter(_msg: Dictionary = {}) -> void:
	owner.stats.set_invulnerable_for_seconds(wait_duration*3)
	
	var timer := get_tree().create_timer(wait_duration)
	yield(timer, "timeout")
	
	owner.emit_signal("hopped_off_entity")
	
	owner.state_machine.transition_to('Move/Air', {impulse = hop_impulse, velocity = Vector2.ZERO})
