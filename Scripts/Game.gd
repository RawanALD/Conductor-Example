extends Node2D

# How long the whole minigame should last, in seconds.
@export var game_length_seconds: float = 30.0

# How many misses (unhit notes or wrong presses) before it's a fail.
@export var max_misses: int = 5

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0
var misses = 0

var bpm = 115

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var beats_before_start = 8
var end_beat = 0
var stage_2_beat = 0
var stage_3_beat = 0

var spawn_1_beat = 1
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var lane = 0
var rand = 0
var note = load("res://Scenes/Note.tscn")
var instance


func _ready():
	randomize()
	# Work out how many beats fit in game_length_seconds, then split that
	# window into three difficulty stages (intro / build / finale).
	end_beat = beats_before_start + int(game_length_seconds / sec_per_beat)
	stage_2_beat = beats_before_start + int((end_beat - beats_before_start) * 0.35)
	stage_3_beat = beats_before_start + int((end_beat - beats_before_start) * 0.7)
	$Conductor.play_with_beat_offset(beats_before_start)


func _input(event):
	if event.is_action("escape"):
		if get_tree().change_scene_to_file("res://Scenes/Menu.tscn") != OK:
			print ("Error changing scene to Menu")


func _on_Conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _on_Conductor_beat(position):
	song_position_in_beats = position

	# Stage 1 (intro) is the default spawn_*_beat values set above.
	if song_position_in_beats > stage_2_beat:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 2
		spawn_4_beat = 0
	if song_position_in_beats > stage_3_beat:
		spawn_1_beat = 2
		spawn_2_beat = 1
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > end_beat:
		_end_game(true)


func _end_game(success):
	$Conductor.stop()
	set_physics_process(false)
	Global.outcome = "success" if success else "fail"
	Global.set_score(score)
	Global.combo = max_combo
	Global.great = great
	Global.good = good
	Global.okay = okay
	Global.missed = missed
	if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
		print ("Error changing scene to End")



func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = randi() % 3
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
		


func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
		misses += 1
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
	$Label.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""

	if misses >= max_misses:
		_end_game(false)


func reset_combo():
	combo = 0
	$Combo.text = ""
