extends Area2D

@export var dialogue: DialogueResource;
@export var sfx: AudioStream
@export var item: PickupItemData

var new_dialogue: InteractAreaDialogue;

func _ready() -> void:
	new_dialogue = InteractAreaDialogue.new()
	new_dialogue.dialogue = dialogue
	new_dialogue.sfx = sfx

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var player = Locator.get_player()
		
		player.set_is_in_interactable_area(true);
		player.set_current_interacting_dialogue(new_dialogue);
		if(item && !player.inventory.has(item)):
			player.inventory.append(item)

			




func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);
