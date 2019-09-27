extends CanvasItem
class_name HeatmapGD
"""
GDScript based solution to generate a heatmap that points from all available tiles,
to the player's location. The heatmap updating itself happens in a thread to keep
the game from skipping.
"""

onready var _grid: TileMap = get_node(pathfinding_tilemap)

export var pathfinding_tilemap: = NodePath()
export var font: Font
export var draw_debug: bool = true

var _pathfinder: = Pathfinder.new()
var _map_limits: Rect2

var _cells_heat: Array = []
var _cells_heat_cache: Array
var _last_player_cell_position: = Vector2(INF, INF)

var _mutex: = Mutex.new()
var _thread: = Thread.new()

var _finished_updating: = false
var _updating: = false

var _x_min: float
var _x_max: float
var _y_min: float
var _y_max: float


func _ready() -> void:
	_map_limits = _grid.get_used_rect()
	_pathfinder.initialize(_grid, range(4,14))
	
	var highest_index: = calculate_point_index(_map_limits.size - _map_limits.position)
	_cells_heat.resize(highest_index)
	_cells_heat_cache = [] + _cells_heat
	
	_x_min = _map_limits.position.x
	_y_min = _map_limits.position.y
	_x_max = _map_limits.size.x - _map_limits.position.x
	_y_max = _map_limits.size.y - _map_limits.position.y
	
	Events.connect("player_moved", self, "_on_Events_player_moved")


func _draw() -> void:
	if not draw_debug or not font:
		return
	for y in range(_y_min, _y_max):
		for x in range(_x_min, _x_max):
			var point: = Vector2(x, y)
			var cell_index: = calculate_point_index(point)
			var heat: int = _cells_heat[cell_index]
			draw_string(font, _grid.map_to_world(point), str(heat))


func best_direction_for(location: Vector2, is_world_location: bool = true) -> Vector2:
	var point: = _grid.world_to_map(location) if is_world_location else location
	var cell_index: = calculate_point_index(point)
	
	var best_neighbour: = point
	var best_heat: int = _cells_heat[cell_index]
	
	if not _is_out_of_bounds(point):
		for y in range(0, 3):
			for x in range(0, 3):
				var point_relative: = Vector2(point.x + x - 1, point.y + y - 1)
				
				if point_relative == point or _is_out_of_bounds(point_relative):
					continue
				
				var point_relative_index: = calculate_point_index(point_relative)
				
				if point_relative_index >= 0 and point_relative_index < _cells_heat.size():
					var heat: int = _cells_heat[point_relative_index]
					if heat and heat < best_heat:
						best_heat = heat
						best_neighbour = point_relative
	
	var world_neighbour: = _grid.map_to_world(best_neighbour)
	var world_location: = _grid.map_to_world(location) if not is_world_location else location
	return (world_neighbour - world_location).normalized()


func calculate_point_index(point : Vector2) -> int:
	point -= _map_limits.position
	return int(point.x + _map_limits.size.x * point.y)


func calculate_point_index_for_world_position(world_position: Vector2) -> int:
	return calculate_point_index(_grid.world_to_map(world_position))


func _refresh_cells_heat(player_cell_position: Vector2) -> void:
	for y in range(_y_min, _y_max):
		for x in range(_x_min, _x_max):
			var point: = Vector2(x,y)
			var cell_index: int = calculate_point_index(point)
			
			var path: Array = _pathfinder.find_path(point, player_cell_position)
			if path.size() == 0:
				continue
			
			var heat: int = path.size()
			
			_cells_heat_cache[cell_index] = heat
	
	_mutex.lock()
	_finished_updating = true
	_mutex.unlock()


func _is_out_of_bounds(player_cell_position: Vector2) -> bool:
	return (player_cell_position.x < _x_min
		or player_cell_position.y < _y_min
		or player_cell_position.x > _x_max
		or player_cell_position.y > _y_max)


func _on_Events_player_moved(player: Player) -> void:
	if _updating:
		return
	
	var player_cell_position: Vector2 = _grid.world_to_map(player.global_position)
	var out_of_bounds: = _is_out_of_bounds(player_cell_position)
	
	if (not out_of_bounds
		and (player_cell_position.x != _last_player_cell_position.x
			or player_cell_position.y != _last_player_cell_position.y)):
			
		_updating = true
		_finished_updating = false
		
		_thread.start(self, "_refresh_cells_heat", player_cell_position)
		
		while true:
			var locked: = _mutex.try_lock()
			if locked == OK and _finished_updating:
				_mutex.unlock()
				break
			_mutex.unlock()
			yield(get_tree(), "idle_frame")
		
		_thread.wait_to_finish()
		
		_cells_heat = [] + _cells_heat_cache
		
		_last_player_cell_position = player_cell_position
		
		_updating = false
		update()