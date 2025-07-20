extends Control

var title_menu = load("uid://l6xve34c75ym");
const STARTING_WORLD = preload("uid://bienm2jvdt34q");

func _on_return_button_pressed() -> void:
	Locator.get_scaffold().scaffold_new_node_tree(title_menu.instantiate());

func _on_play_button_pressed() -> void:
	Locator.get_dude_manager().reset_dudes()
	
	var starting_world_instance = STARTING_WORLD.instantiate();
	var children: Array[Node] = starting_world_instance.get_children();
	var character_spawn: Vector2;
	for child in children:
		if (child is Marker2D && child.name == "SpawnPoint"):
			character_spawn = child.global_position;
	if (character_spawn != null):
		Locator.get_scaffold().scaffold_new_node_tree(STARTING_WORLD.instantiate(), func(): PlayerMessenger.spawn_player.emit(character_spawn));
	
