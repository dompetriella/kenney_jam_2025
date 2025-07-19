extends Node
class_name Game

@onready var menu_camera: Camera2D = %MenuCamera

func _ready() -> void:
	GameMessenger.change_camera_focus.connect(_on_change_camera_focus.bind());
	menu_camera.make_current();
	
func _on_change_camera_focus(focus: CameraType.Focus):
	match (focus):
		CameraType.Focus.PLAYER:
			PlayerMessenger.switch_to_player_camera.emit();
		CameraType.Focus.MENU:
			menu_camera.make_current();
