extends CanvasLayer

"""
Example of usage of DebugPanels from other classes
"""
func _ready():
	$StatsDebugPanel.reference_node = get_node("../Player/Stats")
	$StatsDebugPanel.properties = PoolStringArray(["health", "attack"])
	$StatsDebugPanel.setup()
	
	#Let's say you want a new property to be set in the middle of a test
	yield(get_tree().create_timer(1.0), "timeout")
	$StatsDebugPanel.add_property_label("armor")
	
