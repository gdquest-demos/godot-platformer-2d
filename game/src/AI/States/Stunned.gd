extends State
# State that connects to the player's signal about hopping off an entity,
 # and gets knocked away before transitioning.


export var knock_back_speed := 450.0

var knocked_away := false
var current_speed: float
var knock_back_direction: Vector2

var _player: Player


func enter(msg: Dictionary = {}) -> void:
	knock_back_direction = (msg.hook_position - owner.global_position).normalized()
	knocked_away = false
	_player = msg.player
	_player.connect("hopped_off_entity", self, "_on_Player_hopped_off_entity", [], CONNECT_ONESHOT)
	current_speed = knock_back_speed


func physics_process(delta: float) -> void:
	if knocked_away:
		owner.move_and_collide(knock_back_direction * delta * current_speed)
		current_speed *= 0.95


func _on_Player_hopped_off_entity() -> void:
	knocked_away = true
	yield(get_tree().create_timer(0.5), "timeout")
	_state_machine.transition_to("Destroyed")
