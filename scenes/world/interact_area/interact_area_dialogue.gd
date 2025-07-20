extends Area2D
class_name InteractAreaDialogue

@export var dialogue: DialogueResource;
@export var enemy_data: EnemyData

var talked_to: bool = false;

func _ready() -> void:
	PlayerMessenger.combat_started.connect(_enemy_attack.bind());

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(true);
		Locator.get_player().set_current_interacting_dialogue(self);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);

	
func _enemy_attack(interact_node: InteractAreaDialogue):
	if (interact_node.dialogue == dialogue && enemy_data != null):
		var damage: int = randi_range(enemy_data.enemy_min_damage, enemy_data.enemy_max_damage);
		Locator.get_dude_manager().use_dude(damage);
		talked_to = true;
