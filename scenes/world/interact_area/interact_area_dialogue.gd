extends Area2D
class_name InteractAreaDialogue

@export var dialogue: DialogueResource;
@export var enemy_data: EnemyData

var enemy_total_health: int;
var enemy_current_health: int;
var enemy_is_beaten: bool = false;
var enemy_cooldown_timer: Timer;

func _ready():
	if (enemy_data != null):
		enemy_current_health = enemy_data.enemy_health;
		PlayerMessenger.combat_started.connect(_start_combat);
		PlayerMessenger.combat_ended.connect(_end_combat);
		

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(true);
		Locator.get_player().set_current_interacting_dialogue(self);


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		Locator.get_player().set_is_in_interactable_area(false);
		Locator.get_player().set_current_interacting_dialogue(null);

func _end_combat():
	if (enemy_cooldown_timer != null):
		enemy_cooldown_timer.stop();

func _start_combat():
	enemy_cooldown_timer = Timer.new();
	enemy_cooldown_timer.wait_time = enemy_data.enemy_attack_cooldown;
	enemy_cooldown_timer.one_shot = false;
	self.add_child(enemy_cooldown_timer);
	enemy_cooldown_timer.start();
	enemy_cooldown_timer.timeout.connect(_enemy_attack);
	
func _enemy_attack():
	var damage: int = randi_range(enemy_data.enemy_min_damage, enemy_data.enemy_max_damage);
	Locator.get_dude_manager().use_dude(damage);

func take_damage(damage: int):
	enemy_current_health -= damage;
	if (enemy_current_health <= 0):
		enemy_is_beaten = true;
