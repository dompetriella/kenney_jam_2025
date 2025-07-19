extends Node

func get_scaffold() -> Scaffold:
	var scaffold: Scaffold = get_tree().get_first_node_in_group("Scaffold");
	return scaffold;
