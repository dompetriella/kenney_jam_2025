extends Control
var title_menu = load("uid://l6xve34c75ym");

func _on_return_button_pressed() -> void:
	ScaffoldMessenger.scaffold_new_node_tree.emit(title_menu.instantiate(), TransitionType.Transition.FADE_OUT, TransitionType.Transition.FADE_IN);

	AudioMessenger.stop_music.emit();
