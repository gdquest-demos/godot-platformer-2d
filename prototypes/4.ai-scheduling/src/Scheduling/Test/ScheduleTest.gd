extends SchedulableJob

var _id : int
var _last_index : int = 0
var _iteration : int = 0

func _init(id :int) -> void:
	_id = id


func _run(microseconds_budget : int) -> void:
	var last_time = Scheduler.get_elapsed_microseconds()
	for i in range(_last_index, 10000):
		var current_time = Scheduler.get_elapsed_microseconds()
		if (current_time - last_time) > microseconds_budget:
			_last_index = i
			return
	print(_id, " done ", _iteration, " - repeating.")
	_iteration += 1
	_last_index = 0