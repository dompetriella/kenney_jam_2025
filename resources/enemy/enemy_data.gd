extends Resource
class_name EnemyData

@export var enemy_name: String;
@export var enemy_health: int;
@export var enemy_min_damage: int;
@export var enemy_max_damage: int;
@export var enemy_attack_cooldown: float;
@export var enemy_weakness: DudeType.Dude = DudeType.Dude.BLUE;
