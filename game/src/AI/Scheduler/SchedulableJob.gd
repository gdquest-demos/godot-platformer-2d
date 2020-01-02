extends Reference
class_name SchedulableJob
# A SchedulableJob to be used as an extension to create individual jobs.

# # A job runs at a set frequency, offset by its calculated phase. When its time is up, `_run` will be
# called with the amount of microseconds it is allowed to use before it should save its current state
# and return, to be resumed at its next call. However, there is no mechanism in place to forcibly
# abort a function - it is up to the job to play nice and keep track of how much time it's taken.

# # The Scheduler has a helper function `get_elapsed_microseconds` that is a wrapper around godot's
# `OS.get_ticks_usec()` call that can be used for this purpose.

# # Notes
# -----
# 1 second == 1,000 milliseconds == 1,000,000 microseconds
# In most 60 fps games, an average frame takes 16.66 milliseconds to both update and render.

# warning-ignore:unused_class_variable
var priority: int
# warning-ignore:unused_class_variable
var frequency: int
# warning-ignore:unused_class_variable
var phase: int

# warning-ignore:unused_argument
func _run(microseconds_budget: int) -> void:
	pass
