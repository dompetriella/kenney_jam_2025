extends Node
class_name Scaffold

@onready var transition_player: AnimationPlayer = %TransitionPlayer

const transition_names := {
	TransitionType.Transition.FADE_IN : "fade_in",
	TransitionType.Transition.FADE_OUT : "fade_out"
}

func scaffold_new_node_tree(
	new_node: Node,
	data_to_load: Callable = Callable(),
	transition_in: TransitionType.Transition = TransitionType.Transition.FADE_OUT,
	transition_out: TransitionType.Transition = TransitionType.Transition.FADE_IN,

) -> void:
	
	if (transition_in != TransitionType.Transition.NONE):
		transition_player.play(transition_names[transition_in])
		await transition_player.animation_finished
	
	for child in get_children():
		child.queue_free()

	await get_tree().process_frame

	add_child(new_node)
	
	if data_to_load.is_valid():
		await data_to_load.call()

	if (transition_out != TransitionType.Transition.NONE):
		transition_player.play(transition_names[transition_out])
		await transition_player.animation_finished;
