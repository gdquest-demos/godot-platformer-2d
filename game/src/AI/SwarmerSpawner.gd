extends Node2D
# Spawns a number of swarmer enemies in the scene, who use the heatmap behavior
# to chase the player for economical pathfinding.


export var spawner_count := 50
export var spawn_per_frame := 10
export var swarmer: PackedScene
export var spawn_radius := 200
export var minimum_speed: float = 200
export var maximum_speed: float = 300


func _ready():
	randomize()
	var r_squared := spawn_radius*spawn_radius
	
	for i in range(spawner_count):
		if i % spawn_per_frame:
			yield(get_tree(), "idle_frame")
		var x := rand_range(-spawn_radius, spawn_radius)
		var y := rand_range(-1, 1) * sqrt(r_squared-x*x)
		
		var instance := swarmer.instance()
		instance.set_name("Swarmer%s"% i)
		add_child(instance)
		instance.speed = rand_range(minimum_speed, maximum_speed)
		instance.global_position = global_position + Vector2(x,y)
