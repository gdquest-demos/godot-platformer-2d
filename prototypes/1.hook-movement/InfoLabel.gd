extends Label

func _ready() -> void:
	Events.connect("player_info_updated", self, "_on_Events_player_info_updated")


func _on_Events_player_info_updated(info:Dictionary) -> void:
	text = ""
	for key in info:
		if info[key] is Vector2:
			text += "%s: (%01d %01d)" % [key, info[key].x, info[key].y]
		else:
			text += "%s: %s\n" % [key, info[key]]
#		text += "\n"
