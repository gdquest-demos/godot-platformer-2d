extends SchedulableJob
class_name BalancedSubScheduler
# A scheduler that spreads its budget evenly between all jobs. It runs as a job itself on the
# priority scheduler as a low priority job. The user shouldn't interact with this directly.

var _current_frame: int = 0
var _job_list: Array = []
var _run_list: Array = []

func _add_new_job(job, frequency: int, phase: int) -> void:
	job.phase = phase
	job.frequency = frequency
	_job_list.append(weakref(job))


func _remove_job(job: SchedulableJob) -> void:
	var index := _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)


func _run(microseconds_budget: int) -> void:
	_current_frame += 1
	
	_run_list.clear()
	
	var i := _job_list.size()-1
	while i >= 0:
		var job := ((_job_list[i] as WeakRef).get_ref() as SchedulableJob)
		i -= 1
		if !job:
			_job_list.remove(i+1)
			continue
		
		if (_current_frame + job.phase) % job.frequency == 0:
			_run_list.append(job)
	
	var current_job := 0
	var usec_budget := microseconds_budget
	var last_time := OS.get_ticks_usec()
	
	var list_size := _run_list.size()
	for i in range(0, list_size):
		var job := _run_list[i] as SchedulableJob
		var current_time := OS.get_ticks_usec()
		usec_budget -= current_time - last_time
		
		var available_time := int(float(usec_budget) / float(_run_list.size() - current_job))
		job._run(available_time)
		
		last_time = current_time
		current_job += 1
