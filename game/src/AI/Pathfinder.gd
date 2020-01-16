# Finds the path between two points using AStar, in grid coordinates

# # Code by razcore as part of the GDQuest OpenRPG project:
	# https://github.com/GDquest/godot-open-rpg
# It's been modified and extended a little to not allow diagonals, and to allow
# tiles that lie on the negative side of the Tilemap planes.
class_name Pathfinder


var astar : AStar = AStar.new()

var _obstacles : Array
var _map_size : Rect2
var _x_min: float
var _x_max: float
var _y_min: float
var _y_max: float


func initialize(grid : TileMap, obstacle_tile_ids : Array) -> void:
	# Initializes the AStar node: finds all walkable cells 
	# and connects all walkable paths
	# Initialize map size and obstacles array
	_map_size = grid.get_used_rect()
	_x_min = _map_size.position.x
	_x_max = _map_size.size.x - _map_size.position.x
	_y_min = _map_size.position.y
	_y_max = _map_size.size.y - _map_size.position.y
	
	for id in obstacle_tile_ids:
		var occupied_cells = (grid as TileMap).get_used_cells_by_id(id)
		for cell in occupied_cells:
			_obstacles.append(cell)
	
	# Find all walkable cells and store them in an array
	var points_array  := []
	for y in range(_y_min, _y_max):
		for x in range(_x_min, _x_max):
			var point = Vector2(x, y)
			if point in _obstacles:
				continue
			points_array.append(point)
			var point_index = calculate_point_index(point)
			astar.add_point(point_index, Vector3(point.x, point.y, 0))
	# Loop through all walkable cells and their neighbors
	# to connect the points
	for point in points_array:
		var point_index = calculate_point_index(point)
		for y in range(0, 3):
			for x in range(0, 3):
				var point_relative := Vector2(point.x + x - 1, point.y + y - 1)
				
				#only connect south-north and west-east, no diagonals
				if point_relative.x != point.x and point_relative.y != point.y:
					continue
				var point_relative_index := calculate_point_index(point_relative)
				
				if (point_relative != point and not is_outside_map_bounds(point_relative) 
						and astar.has_point(point_relative_index)):
					astar.connect_points(point_index, point_relative_index)


func is_outside_map_bounds(point : Vector2) -> bool:
	return (point.x < _x_min
			or point.y < _y_min
			or point.x >= _x_max
			or point.y >= _y_max)


func calculate_point_index(point : Vector2) -> int:
	point -= _map_size.position
	return int(point.x + _map_size.size.x * point.y)


func find_path(start : Vector2, end : Vector2) -> PoolVector3Array:
	# Returns an array of cells that connect the start and end positions
	# in grid coordinates
	var start_index = calculate_point_index(start)
	var end_index = calculate_point_index(end)
	return astar.get_point_path(start_index, end_index)
