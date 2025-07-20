extends CharacterBody2D
class_name Player

const IDLE_DOWN_ANIMATION: String = 'idle_down';
const WALK_DOWN_ANIMATION: String = 'walk_down';

@export var move_speed: float = 300.0

@onready var character_sprite_animation: AnimatedSprite2D = %CharacterSpriteAnimation
@onready var player_camera: Camera2D = %PlayerCamera
@onready var damage_label: Label = %DamageLabel

var player_can_move: bool = true;
var is_traveling_up: bool = false;
var is_in_interactable_area: bool = false;
var is_in_combat: bool = false;

var current_dialogue_node: InteractAreaDialogue;
var current_pickup_item: PickupItem;

var inventory: Array[PickupItemData] = [];

func _ready() -> void:
	PlayerMessenger.spawn_player.connect(_on_spawn.bind());
	PlayerMessenger.combat_started.connect(_start_combat);
	PlayerMessenger.combat_ended.connect(_end_combat);
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended);
	character_sprite_animation.modulate = Color("#8E7DBE");
	damage_label.visible = false;

func _unhandled_input(event: InputEvent) -> void:
	if (is_in_interactable_area):
		if (current_pickup_item != null):
			if Input.is_action_pressed("ui_select"):
				DialogueManager.show_dialogue_balloon(current_pickup_item.pickup_item_data. pickup_dialogue);
				inventory.append(current_pickup_item.pickup_item_data);
			return;
		
		if (current_dialogue_node != null):
			if (current_dialogue_node.dialogue != null):
				if Input.is_action_pressed("ui_select"):
					DialogueManager.show_dialogue_balloon(current_dialogue_node.dialogue);
				


func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	if (player_can_move):
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1
		if Input.is_action_pressed("ui_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("ui_down"):
			input_vector.y += 1
			is_traveling_up = false;
		if Input.is_action_pressed("ui_up"):
			input_vector.y -= 1
			is_traveling_up = true;
		
		input_vector = input_vector.normalized();
		velocity = input_vector * move_speed
		move_and_slide()

		if input_vector == Vector2.ZERO:
			character_sprite_animation.play(IDLE_DOWN_ANIMATION);

		else:
			character_sprite_animation.play(WALK_DOWN_ANIMATION);

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if current_pickup_item == null:
		pass;
		# PlayerMessenger.combat_started.emit();
	else:
		current_pickup_item.queue_free();
		current_pickup_item = null;
		

func set_is_in_interactable_area(is_in_area: bool):
	is_in_interactable_area = is_in_area;

func set_current_interacting_dialogue(dialogue_node: InteractAreaDialogue):
	current_dialogue_node = dialogue_node;

func set_current_interacting_item(item: PickupItem):
	current_pickup_item = item;
	
func _on_spawn(spawn_position: Vector2i):
	self.visible = true;
	self.global_position = spawn_position;
	player_camera.make_current();

func _on_change_player_position(new_position: Vector2):
	self.global_position = new_position;

func _start_combat():
	is_in_combat = true;
	player_can_move = false;

func _end_combat():
	is_in_combat = false;
	player_can_move = true;
