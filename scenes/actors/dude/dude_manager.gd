# dude_spawn.gd
extends Node

class_name DudeManager

@export var dude_scene: PackedScene
@export var zap_dude_scene: PackedScene
@export var green_dude_scene: PackedScene

var dudes: Array[DudeNode] = []
var blue_dudes := 5
var zap_dudes := 5
var green_dudes := 5
var num_dudes := blue_dudes + zap_dudes + green_dudes
var dudes_lost := 0

func _ready():
	# Wait a frame to ensure Player node is ready
	await get_tree().process_frame
	PlayerMessenger.spawn_player.connect(_on_spawn.bind());
	
	var player = get_parent() as Player  # Get the Player node
	
	add_dudes(dude_scene, blue_dudes, player)
	add_dudes(zap_dude_scene, zap_dudes, player)
	add_dudes(green_dude_scene, zap_dudes, player)
	
	# Setup other_dudes array for each dude after all are created
	for dude in dudes:
		dude.setup(dudes)
		
func add_dudes(scene: PackedScene, amount: int, player: Player) -> void:
	for i in range(amount):
		var dude := scene.instantiate() as DudeNode
		dude.name = "Dude" + str(dudes.size())
		dude.add_to_group("dudes")
		dude.target = player
		dudes.append(dude)
		add_child(dude)
		
		# Position dude near player initially
		var angle = (i * TAU) / num_dudes
		var offset = Vector2(cos(angle), sin(angle)) * 10
		dude.global_position = player.global_position + offset

func use_dude(cost: int) -> void:
	if cost < dudes.size():
		for i in range(cost):
			var sacrifice: DudeNode
			if i < dudes.size():
				sacrifice = dudes.pop_at(i)
			else:
				sacrifice = dudes.pop_front()
			
			# update dude count
			match sacrifice.type:
				DudeType.Dude.BLUE:
					blue_dudes -= 1
				DudeType.Dude.GREEN:
					green_dudes -= 1
				DudeType.Dude.YELLOW:
					zap_dudes -= 1
			num_dudes -= 1
			
			sacrifice.queue_free()
		
		dudes_lost += cost
			
func yeet(target: Vector2) -> void:
	if dudes.size() > 0:
		var dude: DudeNode = dudes.pop_front()
		dude.yeet(target)
		match dude.type:
			DudeType.Dude.BLUE:
				blue_dudes -= 1
			DudeType.Dude.YELLOW:
				zap_dudes -= 1
			DudeType.Dude.GREEN:
				green_dudes -= 1
		num_dudes -= 1
		dude.queue_free()
		

func _on_spawn(spawn_position: Vector2i):
	await get_tree().process_frame
	for i in dudes.size():
		var angle = (i * TAU) / dudes.size()
		var offset = Vector2(cos(angle), sin(angle)) * 10
		var player = get_parent() as Player  # Get the Player node
		dudes[i].global_position = player.global_position + offset
