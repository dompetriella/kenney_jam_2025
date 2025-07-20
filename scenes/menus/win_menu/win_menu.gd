extends Control

var title_menu = load("uid://l6xve34c75ym");
var dudes_killed = Locator.get_dude_manager().dudes_lost

func _ready() -> void:
	GameMessenger.change_camera_focus.emit(CameraType.Focus.MENU)
	if dudes_killed > 0:
		$MarginContainer/VBoxContainer/dude_count.text = str(dudes_killed) + " dudes. You are a monster."
	else:
		$MarginContainer/VBoxContainer/dude_count.text = "...actually, it turns out you didn't kill any dudes. You're a good wizard!"

	
	
func _on_play_again_button_pressed() -> void:
	Locator.get_dude_manager().reset_dudes()
	Locator.get_scaffold().scaffold_new_node_tree(title_menu.instantiate(), func(): GameMessenger.reset_game_values.emit());
