# dude_spawn.gd
extends Node

@export var dude_scene: PackedScene
var dudes: Array[DudeNode] = []

func _ready():
	# Wait a frame to ensure Player node is ready
	await get_tree().process_frame
	PlayerMessenger.spawn_player.connect(_on_spawn.bind());

	
	var num_dudes = 20
	var player = get_parent() as Player  # Get the Player node
	
	for i in range(num_dudes):
		var dude = dude_scene.instantiate() as DudeNode
		#dude.collision_layer = 2
		dude.name = "Dude" + str(i)
		dude.add_to_group("dudes")
		
		# Set the target (player) before adding to scene
		dude.target = player
		
		dudes.append(dude)
		add_child(dude)
		
		# Position dude near player initially
		var angle = (i * TAU) / num_dudes
		var offset = Vector2(cos(angle), sin(angle)) * 30
		dude.global_position = player.global_position + offset
	
	# Setup other_dudes array for each dude after all are created
	for dude in dudes:
		dude.setup(dudes)

func _on_spawn(spawn_position: Vector2i):
	for i in dudes.size():
		var angle = (i * TAU) / dudes.size()
		var offset = Vector2(cos(angle), sin(angle)) * 10
		var player = get_parent() as Player  # Get the Player node
		dudes[i].global_position = player.global_position + offset
