extends Node2D
"""
A test node. Uses a prohibitively tight schedule for emphasis, and separates priority VS 
non-priority jobs, as well as testing that the WeakRefs are being cleared from the
scheduler when released.
"""

const ScheduleTest: = preload("res://src/Scheduling/Test/ScheduleTest.gd")

var _test: = ScheduleTest.new(0)
var _test2: = ScheduleTest.new(1)
var _elapsed_time: float = 0

func _ready() -> void:
	Scheduler.add_new_job(_test, 1)
	Scheduler.add_new_priority_job(_test2, 1, 2)
	#Anticipated result is test2 to run more often than test1
	Scheduler.set_microseconds_budget(150)


func _process(delta) -> void:
	_elapsed_time += delta
	if _elapsed_time > 5:
		queue_free()