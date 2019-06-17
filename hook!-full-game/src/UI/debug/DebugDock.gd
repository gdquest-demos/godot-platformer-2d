extends Control

onready var debug_panel: Panel = $DebugPanel

func _ready() -> void:
	debug_panel.properties = PoolStringArray(['velocity'])
