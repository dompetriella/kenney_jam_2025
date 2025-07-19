extends Node

var dudes: Array[DudeNode] = []

func _ready():
	var num_dudes = 10
	
	for i in range(num_dudes):
		var dude = DudeNode.new()
		dudes.append(dude)
	
	for dude in dudes:
		dude.setup(dudes)
		self.add_child(dude)
	
