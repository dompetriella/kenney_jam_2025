extends Area2D

@export var dialogue_success: DialogueResource;
@export var dialogue_deny: DialogueResource;
@export var sfx: AudioStream

var success_dialogue: InteractAreaDialogue;
var deny_dialoge: InteractAreaDialogue;

func _ready() -> void:
	success_dialogue = InteractAreaDialogue.new()
	success_dialogue.sfx = sfx
	success_dialogue.dialogue = dialogue_success
	deny_dialoge = InteractAreaDialogue.new()
	deny_dialoge.dialogue = dialogue_deny
	deny_dialoge.sfx = sfx

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var player = Locator.get_player()
		print(player.inventory.size())
		
		player.set_is_in_interactable_area(true);
		if player.inventory.size() > 2:
			player.is_win = true;
			player.set_current_interacting_dialogue(success_dialogue);
		else:
			player.set_current_interacting_dialogue(deny_dialoge);



func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);
