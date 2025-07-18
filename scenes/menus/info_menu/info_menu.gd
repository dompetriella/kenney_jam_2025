extends Control

var title_menu = load("uid://l6xve34c75ym");
const STARTING_WORLD = preload("uid://bienm2jvdt34q");

func _on_return_button_pressed() -> void:
	ScaffoldMessenger.scaffold_new_node_tree.emit(title_menu.instantiate(), TransitionType.Transition.FADE_OUT, TransitionType.Transition.FADE_IN);

func _on_play_button_pressed() -> void:
	ScaffoldMessenger.scaffold_new_node_tree.emit(STARTING_WORLD.instantiate(), TransitionType.Transition.FADE_OUT, TransitionType.Transition.FADE_IN);
	
