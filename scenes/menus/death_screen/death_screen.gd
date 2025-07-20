extends Control

var title_menu = load("uid://l6xve34c75ym");

func _on_button_pressed() -> void:
	Locator.get_scaffold().scaffold_new_node_tree(title_menu.instantiate(), func(): GameMessenger.reset_game_values.emit());
