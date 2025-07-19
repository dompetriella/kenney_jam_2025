extends Node

func get_scaffold() -> Scaffold:
	var scaffold: Scaffold = get_tree().get_first_node_in_group("Scaffold");
	return scaffold;

func get_player() -> Player:
	var player: Player = get_tree().get_first_node_in_group("Player");
	return player;
