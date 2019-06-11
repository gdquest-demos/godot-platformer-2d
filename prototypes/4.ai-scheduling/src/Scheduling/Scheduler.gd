extends Node
"""
A node that manages jobs within a certain amount of budgeted time in microseconds (1 second == 1,000,000 microseconds).

Whether added to the root of a scene, autoloaded as a global singleton, or run independently.
The node will run through a number of jobs assigned to it, which extend the SchedulableJob class, and will run them on
the provided frequency. In addition, job frequencies are offset by a automatically calculated phase to try and prevent
spikes of activity; if too many jobs are to run on the same frames, it may fill the budget and some jobs will be skipped.

Jobs can either be prioritized, added via the add_new_priority_job function, or balanced, with the add_new_job function.
Higher priority jobs will get budgeted time before less prioritized jobs. The balanced scheduler is, itself, a low priority
job.

The Scheduler also provides a call_delayed_function function that takes a parameter-less FuncRef and a delay in microseconds.
"""

#int64_t's upper maximum, an equivalent to +infinity
const MAX_INT: int = 0x7FFFFFFFFFFFFFFF

#4 milliseconds maximum budget by default
var microseconds_budget: int = 4000 setget set_microseconds_budget, get_microseconds_budget

var _sub_scheduler: BalancedScheduler = BalancedScheduler.new()
var _current_frame: int = 0
var _simulation_frame_count: int = 100
var _job_list: Array = []
var _run_list: Array = []
var _phase_counters: Array = []
var _delayed_calls: Dictionary = {}

func _ready() -> void:
	add_new_priority_job(_sub_scheduler, 1, 1)


func _process(delta) -> void:
	var last_time: int = OS.get_ticks_usec()
	
	#Delayed callbacks
	var callback_count: int = _delayed_calls.size()
	for i in range(callback_count-1, -1, -1):
		var key: int = _delayed_calls.keys()[i]
		var callback = _delayed_calls[key]
		if last_time >= callback["last_time"]+callback["delay"]:
			if is_instance_valid(callback["instance"]):
				callback["function"].call_func()
				if callback["remove"]:
					_delayed_calls.erase(key)
				else:
					callback["last_time"] = last_time
			else:
				_delayed_calls.erase(key)
	
	#Job system
	_current_frame += 1
	
	_run_list.clear()
	var total_priority: float = 0
	
	for job in _job_list:
		if (_current_frame + job._phase) % job._frequency == 0:
			_run_list.append(job)
			total_priority += job._priority
	
	var current_usecs_to_run: int = microseconds_budget
	for job in _run_list:
		var current_time: int = OS.get_ticks_usec()
		current_usecs_to_run -= current_time - last_time
		var available_time: int = current_usecs_to_run * job._priority / total_priority
		job._run(available_time)
		last_time = current_time


"""
Adds a job at a set frequency, and with a priority that is proportional to the total amount of priority from all other jobs
It will be offset by a phase, so even a frequency of 1 may not be every frame, depending on how busy the scheduler is.
"""
func add_new_priority_job(job: SchedulableJob, frequency: int, priority: float) -> void:
	if job.has_method("_run"):
		job._frequency = frequency
		job._priority = priority
		job._phase = _calculate_phase(frequency)
		_job_list.append(job)


"""
Adds a job at a set frequency. It will be allocated an amount of time budget equal to all other non-prioritized jobs.
It will be offset by a phase, so even a frequency of 1 may not be every frame, depending on how busy the scheduler is.
"""
func add_new_job(job: SchedulableJob, frequency: int) -> void:
	if job.has_method("_run"):
		_sub_scheduler._add_new_job(job, frequency, _calculate_phase(frequency))


"""
Unregisters a job from the scheduler.
"""
func remove_job(job: SchedulableJob) -> void:
	var index: int = _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)
	else:
		_sub_scheduler._remove(job)


"""
A wrapper for OS.get_ticks_usec(). Can be used by jobs to calculate how much time they've spent working relative to their
alloted microsecond budget.

Returns the number of microseconds elapsed since the start of the program.
"""
func get_elapsed_microseconds() -> int:
	return OS.get_ticks_usec()


"""
Sets the amount of microseconds alloted to the scheduler as a whole every frame.
It defaults to 4000 microseconds (4 milliseconds.)
"""
func set_microseconds_budget(new_budget: int) -> void:
	microseconds_budget = new_budget
	

func get_microseconds_budget() -> int:
	return microseconds_budget


"""
Schedules a function to be called after a delay using a funcref. If the object stops existing before its time is up, 
it will be quietly removed. Passing in false to remove_after_call will make it a running event.
"""
func call_delayed_function(instance: Object, callback_name: String, microseconds_delay: int, remove_after_call: bool) -> void:
	var key:int = _generate_hash_key(instance, callback_name)
	_delayed_calls[key] = {
		"last_time":OS.get_ticks_usec(), 
		"delay":microseconds_delay, 
		"function":funcref(instance, callback_name),
		"instance":instance,
		"remove":remove_after_call}


"""
Removes a delayed function from the running, provided it hasn't already been triggered and removed.
"""
func cancel_delayed_function(instance: Object, callback_name: String) -> void:
	var key:int = _generate_hash_key(instance, callback_name)
	if _delayed_calls.has(key):
		_delayed_calls.erase(key)


func _calculate_phase(frequency: int) -> int:
	if frequency > _phase_counters.size():
		_phase_counters.resize(frequency)
	
	for i in range(0, _phase_counters.size()):
		_phase_counters[i] = 0
	
	for frame in range(0, _simulation_frame_count):
		var slot: int = frame % frequency
		for job in _job_list:
			if (frame - job._phase) % job._frequency == 0:
				_phase_counters[slot] += 1
	
	var min_value: int = MAX_INT
	var min_value_at: int = -1
	for i in range(0, frequency):
		if _phase_counters[i] < min_value:
			min_value = _phase_counters[i]
			min_value_at = i
	
	return min_value_at


func _generate_hash_key(instance: Object, func_name: String) -> int:
	var hash_code:int = 17
	hash_code = hash_code * 31 + hash(instance)
	hash_code = hash_code * 31 + hash(func_name)
	return hash_code