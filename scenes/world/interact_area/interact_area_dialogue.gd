extends Area2D

@export var dialogue: String;


func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(true);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
