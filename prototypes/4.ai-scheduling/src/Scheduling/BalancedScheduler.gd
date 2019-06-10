extends SchedulableJob

var _current_frame : int = 0
var _job_list : Array = []
var _run_list : Array = []

func _add_new_job(job, frequency : int, phase : int) -> void:
	if job.has_method("_run"):
		job._phase = phase
		job._frequency = frequency
		_job_list.append(job)


func _remove_job(job : SchedulableJob) -> void:
	var index : int = _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)


func _run(microseconds_budget : int) -> void:
	_current_frame += 1
	
	_run_list.clear()
	
	for job in _job_list:
		if (_current_frame + job._phase) % job._frequency == 0:
			_run_list.append(job)
	
	var last_time : int = OS.get_ticks_usec()
	
	var current_job : int = 0
	var usec_budget : int = microseconds_budget
	for job in _run_list:
		var current_time : int = OS.get_ticks_usec()
		usec_budget -= current_time - last_time
		
		var available_time : int = int(float(usec_budget) / float(_run_list.size() - current_job))
		job._run(available_time)
		
		last_time = current_time
		current_job += 1