extends SchedulableJob
class_name BalancedSubScheduler

var _current_frame: int = 0
var _job_list: Array = []
var _run_list: Array = []

func _add_new_job(job, frequency: int, phase: int) -> void:
	job._phase = phase
	job._frequency = frequency
	_job_list.append(weakref(job))


func _remove_job(job: SchedulableJob) -> void:
	var index: = _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)


func _run(microseconds_budget: int) -> int:
	_current_frame += 1
	
	_run_list.clear()
	
	var i: = _job_list.size()-1
	while i >= 0:
		var job: = ((_job_list[i] as WeakRef).get_ref() as SchedulableJob)
		i -= 1
		if !job:
			_job_list.remove(i+1)
			continue
		
		if (_current_frame + (job as SchedulableJob)._phase) % (job as SchedulableJob)._frequency == 0:
			_run_list.append(job)
	
	var last_time: = OS.get_ticks_usec()
	
	var current_job: = 0
	var usec_budget: = microseconds_budget
	for job in _run_list:
		var current_time: = OS.get_ticks_usec()
		usec_budget -= current_time - last_time
		
		var available_time: = int(float(usec_budget) / float(_run_list.size() - current_job))
		var returned_time: = (job as SchedulableJob)._run(available_time)
		
		if returned_time > 0 and returned_time < available_time:
			usec_budget += returned_time
		
		last_time = current_time
		current_job += 1
		
	return usec_budget