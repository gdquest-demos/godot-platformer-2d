extends Node2D

const ScheduleTest: Resource = preload("res://src/Scheduling/Test/ScheduleTest.gd")
var test: ScheduleTest = ScheduleTest.new(0)
var test2: ScheduleTest = ScheduleTest.new(1)

func _ready() -> void:
	Scheduler.add_new_job(test, 1)
	Scheduler.add_new_priority_job(test2, 1, 2)
	#Anticipated result is test2 to run more often than test1
	Scheduler.set_microseconds_budget(150)
	Scheduler.call_delayed_function(self, "_delayed_call", 5000000, true)

func _process(delta) -> void:
	queue_free()

func _delayed_call() -> void:
	print("!!!!!")