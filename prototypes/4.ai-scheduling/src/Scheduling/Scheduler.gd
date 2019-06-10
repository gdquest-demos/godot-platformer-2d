extends Node
"""
A node that manages jobs within a certain amount of budgeted time.

Whether added to the root of a scene, autoloaded as a global singleton, or run independently.
The node will run through a number of jobs assigned to it, which extend the SchedulableJob class, and will run them on
the provided frequency. In addition, job frequencies are offset by a automatically calculated phase to try and prevent
spikes of activity; if too many jobs are to run on the same frames, it may fill the budget and some jobs will be skipped.

Jobs can either be prioritized, added via the add_new_priority_job function, or balanced, with the add_new_job function.
Higher priority jobs will get budgeted time before less prioritized jobs. The balanced scheduler is, itself, a low priority
job.
"""

const BalancedScheduler : Resource = preload("res://src/Scheduling/BalancedScheduler.gd")

#4 milliseconds maximum budget by default
var microseconds_budget : int = 4000 setget set_microseconds_budget, get_microseconds_budget

var _sub_scheduler : BalancedScheduler = BalancedScheduler.new()
var _current_frame : int = 0
var _simulation_frame_count : int = 100
var _job_list : Array = []
var _run_list : Array = []
var _phase_counters : Array = []

func _ready() -> void:
	add_new_priority_job(_sub_scheduler, 1, 1)


func _process(delta) -> void:
	_current_frame += 1
	
	_run_list.clear()
	var total_priority : float = 0
	
	for job in _job_list:
		if (_current_frame + job._phase) % job._frequency == 0:
			_run_list.append(job)
			total_priority += job._priority
	
	var last_time : int = OS.get_ticks_usec()
	
	var current_usecs_to_run : int = microseconds_budget
	for job in _run_list:
		var current_time : int = OS.get_ticks_usec()
		current_usecs_to_run -= current_time - last_time
		var available_time : int = current_usecs_to_run * job._priority / total_priority
		job._run(available_time)
		last_time = current_time


func add_new_priority_job(job : SchedulableJob, frequency : int, priority : float) -> void:
	if job.has_method("_run"):
		job._frequency = frequency
		job._priority = priority
		job._phase = _calculate_phase(frequency)
		_job_list.append(job)


func add_new_job(job : SchedulableJob, frequency : int) -> void:
	if job.has_method("_run"):
		_sub_scheduler._add_new_job(job, frequency, _calculate_phase(frequency))


func remove_job(job : SchedulableJob) -> void:
	var index : int = _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)
	else:
		_sub_scheduler._remove(job)


func get_elapsed_microseconds() -> int:
	return OS.get_ticks_usec()


func set_microseconds_budget(new_budget : int) -> void:
	microseconds_budget = new_budget
	
	
func get_microseconds_budget() -> int:
	return microseconds_budget


func _calculate_phase(frequency : int) -> int:
	if frequency > _phase_counters.size():
		_phase_counters.resize(frequency)
	
	for i in range(0, _phase_counters.size()):
		_phase_counters[i] = 0
	
	for frame in range(0, _simulation_frame_count):
		var slot : int = frame % frequency
		for job in _job_list:
			if (frame - job._phase) % job._frequency == 0:
				_phase_counters[slot] += 1
	
	var min_value : int = 9e+18
	var min_value_at : int = -1
	for i in range(0, frequency):
		if _phase_counters[i] < min_value:
			min_value = _phase_counters[i]
			min_value_at = i
	
	return min_value_at