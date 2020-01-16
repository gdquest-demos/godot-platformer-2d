extends SteeringBehavior2D
class_name FollowHeatmapBehavior2D
# A 2D steering behavior that expects a heatmap to be somewhere in the scene.
# It uses that to figure out where it should be going - from large values in its cell
# towards smaller values, with 0 being the goal.


var _heatmap

var _last_point_index: int = INF
var _last_velocity := Vector2(0, 0)


func _ready() -> void:
	_heatmap = get_tree().root.find_node("Heatmap", true, false)
	assert(_heatmap)


func _calculate_steering_internal(steering: SteeringMotion2D) -> SteeringMotion2D:
	var actor = get_actor()
	var point_index: int = _heatmap.calculate_point_index_for_world_position(actor.global_position)
	if point_index != _last_point_index:
		_last_point_index = point_index
		var to_target: Vector2 = _heatmap.best_direction_for(actor.global_position, true)
		
		steering.velocity = to_target * controller.max_acceleration
		_last_velocity = steering.velocity
	else:
		steering.velocity = _last_velocity
		
	steering.angular_velocity = 0
	return steering
