extends ColorRect


signal almost_completed

const TRANSITION_ANIM_TOTAL_LENGTH := 3.6
const TRANSITION_ANIM_MIN_LENGTH := 1.0
const TRANSITION_ANIM_AMP := TRANSITION_ANIM_TOTAL_LENGTH - TRANSITION_ANIM_MIN_LENGTH

onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	randomize()


func start_transition_animation() -> void:
	# The animations will be transition_init->transition->transition_finalize
	_change_animation("transition_init") 


func _change_animation(anim_name: String) -> void:
	animation_player.play(anim_name)


func _change_transition_length() -> void:
	var aux_length: float
	aux_length = TRANSITION_ANIM_MIN_LENGTH + rand_range(0,TRANSITION_ANIM_AMP)
	# This while makes imposible to end the animation when flipping_h the player art sprite
	while( (aux_length >= TRANSITION_ANIM_TOTAL_LENGTH * 0.5) and (aux_length < TRANSITION_ANIM_TOTAL_LENGTH / 0.5 + 0.2) ):
		aux_length = TRANSITION_ANIM_MIN_LENGTH + rand_range(0,TRANSITION_ANIM_AMP)
	animation_player.get_animation("transition").length = aux_length


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if(anim_name == "transition_init"):
		_change_transition_length()
		_change_animation("transition")
	elif(anim_name == "transition"):
		_change_animation("transition_finalize")
		# This yield gives 1 second to go to the next level in the background to keep the transition_finalize end clean.
		yield(get_tree().create_timer( animation_player.get_animation("transition_finalize").length - 1), "timeout") 
		emit_signal("almost_completed")


func is_animating() -> bool: 
	# <BASE> is the "do nothing" animation
	return animation_player.current_animation != "<BASE>" 
