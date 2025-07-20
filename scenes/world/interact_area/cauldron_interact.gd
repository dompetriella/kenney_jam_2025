extends Area2D

@export var dialogue_success: DialogueResource;
@export var dialogue_deny: DialogueResource;


func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var player = Locator.get_player()
		
		player.set_is_in_interactable_area(true);
		if player.inventory.size() > 3:
			player.set_current_interacting_dialogue(dialogue_success);
		else:
			player.set_current_interacting_dialogue(dialogue_deny);



func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);
