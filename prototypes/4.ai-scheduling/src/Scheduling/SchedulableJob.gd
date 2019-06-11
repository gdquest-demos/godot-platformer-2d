extends Reference
class_name SchedulableJob
"""
A SchedulableJob to be used as an extension to other jobs.

A job, once added to the scheduler, will be run at its given frequency, offset by a calculated phase (to keep it from
overlapping frames where there is a lot of activity.) It is up to the job to play nice with the allocated budget and
return when its time is up - there are no facilities to interrupt loops and functions. It is also up to the job to determine
what to do when its time is up, and when to check for its time being up.
"""

var _priority: int
var _frequency: int
var _phase: int

func _run(microseconds_budget: int) -> void:
	pass