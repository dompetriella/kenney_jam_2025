extends Control

var info_menu: PackedScene = load("uid://cbp88s7ly7d5m");

func _ready():
	var audio: AudioStream = load("uid://dfacrdhrl11bj");
	AudioMessenger.play_music.emit(audio);

func _on_start_button_pressed() -> void:
	Locator.get_scaffold().scaffold_new_node_tree(info_menu.instantiate());


func _on_quit_button_pressed() -> void:
	self.get_tree().quit();
