extends Control

@onready var blue_dude_amount_label: Label = %BlueDudeAmountLabel
@onready var green_dude_amount_label: Label = %GreenDudeAmountLabel
@onready var yellow_dude_amount_label: Label = %YellowDudeAmountLabel
@onready var total_dude_amount_label: Label = %TotalDudeAmountLabel

func _ready() -> void:
	GameMessenger.dude_amount_changed.connect(_on_dude_amount_changed.bind());

func _on_dude_amount_changed(dude_array: Array[DudeNode]):
	total_dude_amount_label.text = "Total Dudes: " + str(dude_array.size());
	
	var blue_amount: int = 0;
	var green_amount: int = 0;
	var yellow_amount: int = 0;
	
	for dude: DudeNode in dude_array.duplicate():
		if (dude.type == DudeType.Dude.BLUE):
			blue_amount += 1;
		if (dude.type == DudeType.Dude.GREEN):
			green_amount += 1;
		if (dude.type == DudeType.Dude.YELLOW):
			yellow_amount += 1;
	
	blue_dude_amount_label.text = str(blue_amount);
	yellow_dude_amount_label.text = str(yellow_amount);
	green_dude_amount_label.text = str(green_amount);
