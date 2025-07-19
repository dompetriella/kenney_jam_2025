extends CharacterBody2D
class_name Player

const IDLE_DOWN_ANIMATION: String = 'idle_down';
const WALK_DOWN_ANIMATION: String = 'walk_down';

@export var move_speed: float = 300.0

@onready var character_sprite_animation: AnimatedSprite2D = %CharacterSpriteAnimation
@onready var player_camera: Camera2D = %PlayerCamera

var player_can_move: bool = true;
var is_traveling_up: bool = false;
var is_in_interactable_area: bool = false;
var current_interactable: Variant = null;

func _ready() -> void:
	PlayerMessenger.spawn_player.connect(_on_spawn.bind());
	character_sprite_animation.modulate = Color("#8E7DBE");

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
	
	if (is_in_interactable_area):
		print('In da area');

func set_is_in_interactable_area(is_in_area: bool):
	is_in_interactable_area = is_in_area;

func _on_spawn(spawn_position: Vector2i):
	self.visible = true;
	self.global_position = spawn_position;
	player_camera.make_current();

func _on_change_player_position(new_position: Vector2):
	self.global_position = new_position;
