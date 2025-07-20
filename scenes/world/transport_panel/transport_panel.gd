extends Area2D

@export var new_scene_uid: String;
@export var specific_spawn_name: String;

func _on_body_entered(body: Node2D) -> void:
	
	var spawns: Array[Marker2D] = [];
	
	if (new_scene_uid != null):
		if (body is Player):
			var new_scene: PackedScene = load(new_scene_uid);
			var new_scene_instance: Node = new_scene.instantiate();
			var new_player_position: Vector2i;
			for child in new_scene_instance.get_children():
				if (child is Marker2D):
					spawns.append(child)
					
			if (!specific_spawn_name.is_empty()):
				for marker in spawns:
					if (marker.name == specific_spawn_name):
						new_player_position = marker.global_position 
			else:
				new_player_position = spawns.front().global_position;
			if (new_player_position != Vector2i.ZERO):
				Locator.get_scaffold().scaffold_new_node_tree(new_scene.instantiate(), func(): PlayerMessenger.spawn_player.emit(new_player_position));
			else:
				print('No new player position provided for transporter')
				
	else:
		print("No UID for new scene when transporting")
