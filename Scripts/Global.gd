extends Node2D


var score = 0
var combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0
var grade = "NA"

# "success" or "fail" - set by Game.gd when the minigame ends.
var outcome = "success"


func set_score(new):
	score = new
	if score > 250000:
		grade = "A+"
	elif score > 200000:
		grade = "A"
	elif score > 150000:
		grade = "A-"
	elif score > 130000:
		grade = "B+"
	elif score > 115000:
		grade = "B"
	elif score > 100000:
		grade = "B-"
	elif score > 85000:
		grade = "C+"
	elif score > 70000:
		grade = "C"
	elif score > 55000:
		grade = "C-"
	elif score > 40000:
		grade = "D+"
	elif score > 30000:
		grade = "D"
	elif score > 20000:
		grade = "D-"
	else:
		grade = "F"


# TODO: hook these up to your actual inventory/crafting system.
# Called from End.gd once based on Global.outcome.

func grant_al_sadu_pattern():
	# e.g. Inventory.add_item("al_sadu_pattern")
	pass


func return_materials():
	# e.g. Inventory.add_item("wool"); Inventory.add_item("plant")
	pass
