# dude.gd
extends CharacterBody2D

class_name DudeNode

@export var target: Player
@export var SPEED := 100.0
@export var follow_distance := 30.0
@export var crowd_radius := 30.0
@export var separation_force := 20.0
@export var type := DudeType.Dude.BLUE

var other_dudes: Array[DudeNode]
var navigation_agent: NavigationAgent2D

enum State {
	FOLLOWING,
	CROWDING,
	IDLE,
	YEET,
	DEAD
}

var current_state := State.IDLE
var target_position: Vector2

@onready var animation: AnimationPlayer = $DudeSprite/DudeAnimation

func _ready():
	navigation_agent = NavigationAgent2D.new()
	add_child(navigation_agent)
	navigation_agent.radius = 8.0
	navigation_agent.avoidance_enabled = true
	navigation_agent.max_speed = SPEED
	
	# Add collision shape and sprite if they don't exist
	if not has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 8.0
		collision.shape = shape
		add_child(collision)
	
	if not has_node("DudeSprite"):
		var sprite = Sprite2D.new()
		sprite.name = "DudeSprite"
		# You'll need to set a texture here or create a simple colored rectangle
		add_child(sprite)
		
	var timer: Timer = Timer.new();
	timer.autostart = true;
	timer.one_shot = false;
	timer.wait_time = 5.0;
	timer.timeout.connect(_on_timer_timeout);
	self.add_child(timer);
	
func _on_timer_timeout():
	
	var chance_to_spawn: float = 0.10;
	var spin_the_wheel: float = randf();
	if (spin_the_wheel < chance_to_spawn):
		var dude_manager: DudeManager = self.get_parent();
		var packed_dude: PackedScene;
		var dude_ratio: float
		match (self.type):
			DudeType.Dude.BLUE:
				packed_dude = load('uid://parh4vv7b2i5');
				dude_ratio = dude_manager.blue_dudes / dude_manager.num_dudes
			DudeType.Dude.GREEN:
				packed_dude = load('uid://wde1i2q2msdb');
				dude_ratio = dude_manager.green_dudes / dude_manager.num_dudes
			DudeType.Dude.YELLOW:
				packed_dude = load('uid://07yalu1a7pqg');
				dude_ratio = dude_manager.zap_dudes / dude_manager.num_dudes
				
		if (packed_dude != null && dude_ratio < 0.33):
			dude_manager.add_dudes(packed_dude, 1, self.target);
	
func setup(followers_array: Array[DudeNode]):
	other_dudes = followers_array

func _physics_process(delta: float) -> void:
	if not target || current_state == State.DEAD:
		return
		
	update_state()
	
	match current_state:
		State.FOLLOWING:
			follow_player()
		State.CROWDING:
			crowd_around_player()
		State.IDLE:
			idle_behavior()
		State.YEET:
			yeet(target_position)
			
	apply_separation()
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_position = navigation_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * SPEED
		
	move_and_slide()

func update_state():
	if current_state == State.DEAD:
		pass
	
	var distance_to_player := global_position.distance_to(target.global_position)
	var player_moving = target.velocity.length() > 10.0
	
	if player_moving and distance_to_player > follow_distance:
		current_state = State.FOLLOWING
	elif not player_moving and distance_to_player <= follow_distance * 1.5:
		current_state = State.CROWDING
	else:
		current_state = State.IDLE

func follow_player():
	# Fixed: The condition was backwards
	var offset = -target.velocity.normalized() * follow_distance
	if target.velocity.length() < 10.0:  # Changed from > to <
		offset = Vector2.ZERO
	
	target_position = target.global_position + offset
	navigation_agent.target_position = target_position

func yeet(destination: Vector2):
	target_position = destination
	current_state = State.YEET
	if position == target_position:
		current_state = State.DEAD

func crowd_around_player():
	var angle = randf_range(0, 0.5) * TAU
	var distance = randf_range(20.0, crowd_radius)
	var ideal_position = target.global_position + Vector2(cos(angle), sin(angle)) * distance
	
	var valid_position = true
	for dude in other_dudes:
		if dude == self:
			continue
		if ideal_position.distance_to(dude.global_position) < 25.0:
			valid_position = false
			break
	
	if valid_position:
		target_position = ideal_position
		navigation_agent.target_position = target_position
		
func idle_behavior():
	if randf() < 0.01:
		var wander_distance = randf_range(10.0, 15.0)
		var angle = randf_range(0, 0.5) * TAU
		target_position = global_position + Vector2(cos(angle), sin(angle)) * wander_distance
		navigation_agent.target_position = target_position
	
func apply_separation():
	var separation := Vector2.ZERO
	var neighbor_count = 0
	
	for dude in other_dudes:
		if dude == self:
			continue
		
		var distance = global_position.distance_to(dude.global_position)
		if distance < crowd_radius and distance > 0:
			var diff = (global_position - dude.global_position).normalized()
			diff /= distance
			separation += diff
			neighbor_count += 1
	
	if neighbor_count > 0:
		separation /= neighbor_count
		separation = separation.normalized() * separation_force
		velocity += separation * get_physics_process_delta_time()

func _process(_delta: float) -> void:
	# Animation logic - uncomment when you have the sprite set up
	if current_state == State.FOLLOWING || current_state == State.CROWDING:
		if velocity.x > 0:
			animation.play("walk_right")
			$DudeSprite.flip_h = false
		elif velocity.x < 0:
			animation.play("walk_right")
			$DudeSprite.flip_h = true
		else:
			animation.play("idle")
	elif current_state == State.YEET:
		animation.play("die")
	elif current_state == State.DEAD:
		animation.play("dead")
	else:
		animation.play("idle")
	#pass
