extends CharacterBody2D

class_name DudeNode

@onready var animation: AnimationPlayer = $DudeSprite/DudeAnimation

@export var target: Player

const SPEED = 275.0

func _physics_process(_delta: float) -> void:
	_calculate_velocity()
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", target.position - Vector2(0, -9), 1)

	#if (target.position - position).dot(target.velocity) < 0:
		#$DudeSprite/DudeAnimation.play("walk_right")
		#
	
	#var direction = (target.global_position - position).normalized()
	#velocity = direction * SPEED
	
	#print(velocity)
	
	move_and_slide()
	

func _calculate_velocity():
	var distanceToTarget = 10
	var dudeNumber = int(name.replace("Dude", ""))
	var dudeMultiplicator = 1 if dudeNumber == 0 else dudeNumber
	var targetPosition = target.position - Vector2(0, -9)
	
	if position.distance_to(targetPosition) > distanceToTarget * dudeMultiplicator:
		var direction = (targetPosition - position).normalized()
		velocity = direction * SPEED
		velocity.y *= 3
	elif position.y - targetPosition.y < -2 || position.y - targetPosition.y > 2:
		velocity.x = 0;
	else: velocity = Vector2.ZERO

func _process(_delta: float) -> void:
	if velocity.x > 0:
		$DudeSprite/DudeAnimation.play("walk_right")
		$DudeSprite.flip_h = false
	elif velocity.x < 0:
		$DudeSprite/DudeAnimation.play("walk_right")
		$DudeSprite.flip_h = true
	else:
		$DudeSprite/DudeAnimation.play("idle")
		
