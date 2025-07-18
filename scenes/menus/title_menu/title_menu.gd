extends Control

var info_menu: PackedScene = load("uid://cbp88s7ly7d5m");
var starting_music = load("uid://b15bhxr4h3bkx");

func _on_start_button_pressed() -> void:
	ScaffoldMessenger.scaffold_new_node_tree.emit(info_menu.instantiate());

func _on_quit_button_pressed() -> void:
	self.get_tree().quit();
