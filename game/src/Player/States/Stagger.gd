tool
extends State


onready var duration: Timer = $Duration


func _get_configuration_warning() -> String:
	return "" if $Duration else "%s requires a Timer child named Duration" % name


func enter(_msg: Dictionary = {}):
	duration.start()
	yield(duration, "timeout")
	_state_machine.transition_to("Move/Idle")
