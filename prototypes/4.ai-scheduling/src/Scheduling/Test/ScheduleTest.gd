extends SchedulableJob

var _id: int
var _last_index: = 0
var _iteration: = 0

func _init(id: int) -> void:
	_id = id


func _run(microseconds_budget: int) -> void:
	var start_time: = Scheduler.get_elapsed_microseconds()
	for i in range(_last_index, 10000):
		_last_index = i
		if (Scheduler.get_elapsed_microseconds() - start_time) > microseconds_budget:
			break
	
	if _last_index == 9999:
		_last_index = 0
		print(_id, " done ", _iteration, " - repeating.")
		_iteration += 1