extends Node2D


func _ready():
	if Global.outcome == "fail":
		$GradeNumber.text = "FAILED"
		Global.return_materials()
	else:
		$GradeNumber.text = Global.grade
		Global.grant_al_sadu_pattern()
	$ScoreNumber.text = str(Global.score)
	$ComboNumber.text = str(Global.combo)
	$GreatNumber.text = str(Global.great)
	$GoodNumber.text = str(Global.good)
	$OkayNumber.text = str(Global.okay)
	$MissedNumber.text = str(Global.missed)
	


func _on_PlayAgain_pressed():
	if get_tree().change_scene_to_file("res://Scenes/Game.tscn") != OK:
			print ("Error changing scene to Game")


func _on_BackToMenu_pressed():
	if get_tree().change_scene_to_file("res://Scenes/Menu.tscn") != OK:
			print ("Error changing scene to Menu")
