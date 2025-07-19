extends Area2D
class_name PickupItem

@export var pickup_item_data: PickupItemData;
@onready var item_sprite: Sprite2D = %ItemSprite

var interactable = true;

func _ready() -> void:
	item_sprite.texture = pickup_item_data.item_texture;


func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		print(pickup_item_data.item_name);
		Locator.get_player().set_is_in_interactable_area(true);
		Locator.get_player().set_current_interacting_item(self);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		print("Leaving: " + pickup_item_data.item_name);
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_item(null);
		
func remove_item_from_world():
	self.queue_free();
