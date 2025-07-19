extends CharacterBody2D

class_name DudeNode

@export var target: Player
@export var SPEED := 275.0
@export var follow_distance := 50.0
@export var crowd_radius := 30.0
@export var separation_force := 200.0

var other_dudes: Array[DudeNode]
var navigation_agent: NavigationAgent2D

enum State {
	FOLLOWING,
	CROWDING,
	IDLE
}

var current_state := State.IDLE
var target_position: Vector2

@onready var animation: AnimationPlayer = $DudeSprite/DudeAnimation
#@onready var ray_folder := $rayFolder.get_children()
#var dudes_i_see := []

func _ready():
	navigation_agent = NavigationAgent2D.new()
	add_child(navigation_agent)
	navigation_agent.radius = 8.0
	navigation_agent.avoidance_enabled = true
	navigation_agent.max_speed = SPEED
	
func setup(followers_array: Array[DudeNode]):
	other_dudes = followers_array

func _physics_process(_delta: float) -> void:
	if not target:
		return
		
	update_state()
	
	match current_state:
		State.FOLLOWING:
			follow_player()
		State.CROWDING:
			crowd_around_player()
		State.IDLE:
			idle_behavior()
			
	apply_separation()
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_position = navigation_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * SPEED
		
	move_and_slide()
	#_calculate_velocity()
	#boids()
	#check_collision()
	#velocity = velocity.normalized() * SPEED
	
	#move() 
	# Can't do this, because it fucks with the collision detection
	#var tween: Tween = create_tween().set_parallel(true)
	#tween.tween_property(self, "position", target.position - Vector2(0, -9), 1)
	
	#move_and_slide()

func update_state():
	var distance_to_player := global_position.distance_to(target.global_position)
	
	var player_moving = target.velocity.length() > 10.0
	
	if player_moving and distance_to_player > follow_distance:
		current_state = State.FOLLOWING
	elif not player_moving and distance_to_player <= follow_distance * 1.5:
		current_state = State.CROWDING
	else:
		current_state = State.IDLE

func follow_player():
	var offset = -target.velocity.normalized() * follow_distance
	if target.velocity.length() > 10.0:
		offset = Vector2.ZERO
	
	target_position = target.global_position + offset
	navigation_agent.target_position = target_position

func crowd_around_player():
	var angle = randf() * TAU
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
		var wander_distance = randf_range(10.0, 30.0)
		var angle = randf() * TAU
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
#func _calculate_velocity():
	#var distanceToTarget = 10
	#var dudeNumber = int(name.replace("Dude", ""))
	#var dudeMultiplicator = 1 if dudeNumber == 0 else dudeNumber
	#var targetPosition = target.position - Vector2(0, -9)
	#
	#if position.distance_to(targetPosition) > distanceToTarget * dudeMultiplicator:
		#var direction = (targetPosition - position).normalized()
		#velocity = direction * SPEED
		#velocity.y *= 3
	#elif position.y - targetPosition.y < -2 || position.y - targetPosition.y > 2:
		#velocity.x = 0;
	#else: velocity = Vector2.ZERO

func _process(_delta: float) -> void:
	#if velocity.x > 0:
		#$DudeSprite/DudeAnimation.play("walk_right")
		#$DudeSprite.flip_h = false
	#elif velocity.x < 0:
		#$DudeSprite/DudeAnimation.play("walk_right")
		#$DudeSprite.flip_h = true
	#else:
		#$DudeSprite/DudeAnimation.play("idle")
	pass	

func move() -> void:
	var distanceToTarget = 10
	var dudeNumber = int(name.replace("Dude", ""))
	var dudeMultiplicator = 1 if dudeNumber == 0 else dudeNumber
	var targetPosition = target.position - Vector2(0, -9)
	
	if position.distance_to(targetPosition) > distanceToTarget:
		var direction = (targetPosition - position).normalized()
		velocity = direction * SPEED
		#velocity.y *= 3
	elif position.y - targetPosition.y < -2 || position.y - targetPosition.y > 2:
		velocity.x = 0;
	else: velocity = Vector2.ZERO
	

#func boids() -> void:
	#if dudes_i_see:
		#var num_dudes := dudes_i_see.size()
		#var avg_vel := Vector2.ZERO
		#var avg_pos := Vector2.ZERO
		#var steer_away := Vector2.ZERO
		#
		#for dude in dudes_i_see:
			#var d: DudeNode = dude
			#avg_vel += dude.velocity
			#avg_pos += dude.position
			##st eer_away -= (d.global_position - global_position) * (48/(global_position - d.global_position).length())
		#avg_vel /= num_dudes
		#velocity += (avg_vel - velocity)/2
		#
		#avg_pos /= num_dudes
		#velocity += (avg_pos - position)/2
	
#func check_collision() -> void:
	#for ray in ray_folder:
		#var r: RayCast2D = ray
		#if r.is_colliding():
			#if !r.get_collider().is_in_group("boid"):
				#var magnitude := 100/(r.get_collision_point() - global_position).length_squared()
				#velocity -= r.target_position.rotated(rotation) * magnitude
		#pass

#func _on_vision_area_entered(area: Area2D) -> void:
	#if area != self and area.is_in_group("boid"):
		#dudes_i_see.append(area)
#
#
#func _on_vision_area_exited(area: Area2D) -> void:
	#if area:
		#dudes_i_see.erase(area)
