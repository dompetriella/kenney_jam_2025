# dude_spawn.gd
extends Node

class_name DudeManager

@export var dude_scene: PackedScene
@export var zap_dude_scene: PackedScene
@export var green_dude_scene: PackedScene

const START_BLUE := 5
const START_YELLOW := 5
const START_GREEN := 5

var dudes: Array[DudeNode] = []
var blue_dudes := START_BLUE
var zap_dudes := START_YELLOW
var green_dudes := START_GREEN
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
		
	GameMessenger.dude_amount_changed.emit(self.dudes)

func reset_dudes() -> void:
	blue_dudes = START_BLUE
	zap_dudes = START_YELLOW
	green_dudes = START_GREEN
	num_dudes = blue_dudes + zap_dudes + green_dudes
	dudes.all(free_dude)
	dudes = []
	self._ready()

func free_dude(dude: DudeNode) -> bool:
	dude.queue_free()
	return true

func add_dudes(scene: PackedScene, amount: int, player: Player) -> void:
	for i in range(amount):
		var dude := scene.instantiate() as DudeNode
		dude.name = "Dude" + str(dudes.size())
		dude.add_to_group("dudes")
		dude.target = player
		dudes.append(dude)
		add_child(dude)
		GameMessenger.dude_amount_changed.emit(self.dudes)
		
		# Position dude near player initially
		var angle = (i * TAU) / num_dudes
		var offset = Vector2(cos(angle), sin(angle)) * 10
		dude.global_position = player.global_position + offset

func use_dude(cost: int) -> void:
	if cost < dudes.size():
		# Count how many of each type exist right now
		var type_counts := {
			DudeType.Dude.BLUE: 0,
			DudeType.Dude.GREEN: 0,
			DudeType.Dude.YELLOW: 0,
		}
		
		for dude in dudes:
			type_counts[dude.type] += 1

		var removed := 0
		var i := 0
		while removed < cost and i < dudes.size():
			var dude := dudes[i]
			var type := dude.type

			# Only remove if more than 1 of this type exists
			if type_counts[type] > 1:
				type_counts[type] -= 1
				dudes.remove_at(i)
				dude.queue_free()

				match type:
					DudeType.Dude.BLUE:
						blue_dudes -= 1
					DudeType.Dude.GREEN:
						green_dudes -= 1
					DudeType.Dude.YELLOW:
						zap_dudes -= 1

				num_dudes -= 1
				removed += 1
			else:
				i += 1  # Skip this dude if we can't safely remove

		dudes_lost += removed
		GameMessenger.dude_amount_changed.emit(dudes)
			
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
		
		GameMessenger.dude_amount_changed.emit(dudes);

func _on_spawn(spawn_position: Vector2i):
	await get_tree().process_frame
	for i in dudes.size():
		var angle = (i * TAU) / dudes.size()
		var offset = Vector2(cos(angle), sin(angle)) * 10
		var player = get_parent() as Player  # Get the Player node
		dudes[i].global_position = player.global_position + offset
