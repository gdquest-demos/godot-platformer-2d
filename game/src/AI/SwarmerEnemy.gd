extends Node2D
# Basic controller for a node2D - its behavior checks the heatmap and points
# its directional vector towards the less heat (the 'goal')


onready var behavior: FollowHeatmapBehavior2D = $BehaviorController2D/FollowHeatmapBehavior2D

var _motion: SteeringMotion2D = SteeringMotion2D.new()
var speed: float = 250


func _physics_process(delta: float) -> void:
	var desired_velocity := behavior.calculate_steering(_motion)
	position += _motion.velocity.normalized() * speed * delta
