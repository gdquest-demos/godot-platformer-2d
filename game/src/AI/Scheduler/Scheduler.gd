extends Node
# The central node that keeps track of running ongoing jobs and allocates a budget of time that any 
# job should respect.

# # Ideally put in as an auto-loaded global node, the Scheduler is loaded with SchedulableJob reference
# objects. Every frame, it will run through its list and check if it should be updating a given job
# based on its frequency and a phase offset.

# # The phase of a job is to prevent spikes of activity; if there are 100 AI entities created at the
# same time, all vying for an update every 10 frames, there are 9 frames where nothing happens,
# and one frame where every entity fights for time budget. The phase will offset them to try and
# spread the load. However, the phase offset can only be as big as the largest frequency-1.

# # Higher priority jobs added via `add_new_priority_job` will get the lion's share of the budget
# before lower priority ones. In addition, there is a balanced sub scheduler for jobs added via
# `add_new_job`. It is a priority 1 job, and it will spread its allocated part of the budget evenly.

#int64_t's upper maximum, an equivalent to +infinity
const MAX_INT := 0x7FFFFFFFFFFFFFFF

#4 milliseconds maximum budget by default
var microseconds_budget := 4000

var _sub_scheduler := BalancedSubScheduler.new()
var _current_frame := 0
var _simulation_frame_count := 100
var _job_list := []
var _run_list := []
var _phase_counters := []


func _ready() -> void:
	add_new_priority_job(_sub_scheduler, 1, 1)


# warning-ignore:unused_argument
func _process(delta) -> void:
	_current_frame += 1
	
	_run_list.clear()
	var total_priority: float = 0
	
	var i := _job_list.size()-1
	while i >= 0:
		var job := ((_job_list[i] as WeakRef).get_ref() as SchedulableJob)
		i -= 1
		if !job:
			_job_list.remove(i+1)
			continue
		
		if (_current_frame + job.phase) % job.frequency == 0:
			_run_list.append(job)
			total_priority += job.priority
	
	var current_usecs_to_run := microseconds_budget
	var last_time := OS.get_ticks_usec()
	
	var list_size := _run_list.size()
	for i in range(0, list_size):
		var job:= _run_list[i] as SchedulableJob
		
		var current_time := OS.get_ticks_usec()
		current_usecs_to_run -= (current_time - last_time)
		
		var available_time := int(current_usecs_to_run * job.priority / total_priority)
		job._run(available_time)
		last_time = current_time
		total_priority -= job.priority

# Adds a job at a set frequency, and with a priority that is proportional to the total amount of
# priority from all other jobs. It will be offset by a phase; so, a frequency of 1 may not
# be on the very next frame, depending on how busy the scheduler is.
func add_new_priority_job(job: SchedulableJob, frequency: int, priority: float) -> void:
	job.frequency = frequency
# warning-ignore:narrowing_conversion
	job.priority = priority
	job.phase = _calculate_phase(frequency)
	_job_list.append(weakref(job))


# Adds a job at a set frequency. It will be allocated an amount of time budget equal to all other 
# non-prioritized jobs. It will be offset by a phase; so, a frequency of 1 may not be on the very
# next frame, depending on how busy the scheduler is.
func add_new_job(job: SchedulableJob, frequency: int) -> void:
	_sub_scheduler._add_new_job(job, frequency, _calculate_phase(frequency))


# Unregisters a job from the scheduler. Note that jobs do not have to be removed when an object
# is being erased - the scheduler only holds weak references.
func remove_job(job: SchedulableJob) -> void:
	var index := _job_list.find(job)
	if index >= 0:
		_job_list.remove(index)
	else:
		_sub_scheduler._remove(job)


# A wrapper for `OS.get_ticks_usec()`. Can be used by jobs to calculate how much time they've spent
# working relative to their alloted microsecond budget.

# # Returns the number of microseconds elapsed since the start of the program.
func get_elapsed_microseconds() -> int:
	return OS.get_ticks_usec()


# Runs a simulation with the current job loadout to calculate a phase that will offset this job from
# the other frequencies.
func _calculate_phase(frequency: int) -> int:
	if frequency > _phase_counters.size():
		_phase_counters.resize(frequency)
	
	for i in range(0, _phase_counters.size()):
		_phase_counters[i] = 0
	
	for frame in range(0, _simulation_frame_count):
		var slot := frame % frequency
		var i := _job_list.size()-1
		while i >= 0:
			var job = ((_job_list[i] as WeakRef).get_ref() as SchedulableJob)
			i -= 1
			if !job:
				_job_list.remove(i+1)
				continue
			
			if (frame - job.phase) % job.frequency == 0:
				_phase_counters[slot] += 1
	
	var min_value := MAX_INT
	var min_value_at := -1
	for i in range(0, frequency):
		if _phase_counters[i] < min_value:
			min_value = _phase_counters[i]
			min_value_at = i
	
	return min_value_at
