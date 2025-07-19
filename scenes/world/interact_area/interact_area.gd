extends Area2D

enum InteractType {
	ADD_TO_INVENTORY,
	DIALOGUE
}

@export var interact_type: InteractType;

var player_in_area: bool = false;

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(true);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
