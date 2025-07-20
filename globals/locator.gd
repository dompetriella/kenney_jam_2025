extends Node

func get_scaffold() -> Scaffold:
	var scaffold: Scaffold = get_tree().get_first_node_in_group("Scaffold");
	return scaffold;

func get_player() -> Player:
	var player: Player = get_tree().get_first_node_in_group("Player");
	return player;
	
func get_game() -> Game:
	var game: Game = get_tree().get_first_node_in_group("Game");
	return game;

func get_dude_manager() -> DudeManager:
	var dude_manager: DudeManager = get_tree().get_first_node_in_group("dudes");
	return dude_manager;
