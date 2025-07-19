extends Area2D

@export var dialogue: DialogueResource;


func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(true);
		Locator.get_player().set_current_interacting_dialogue(dialogue);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);
