extends CanvasLayer


onready var scoreLabel = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/VBoxContainer/GridContainer/ScoreContainer/Score
onready var timeLabel = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/VBoxContainer/GridContainer/ScoreContainer/Time

onready var akn_score = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/VBoxContainer/AcknowledgementContainer/acknowledge_score
onready var akn_time = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/VBoxContainer/AcknowledgementContainer/acknowledge_time

onready var before_cont = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/VBoxContainer/BeforeCont

onready var statsScreen = $StatsScreen

# Gets added to tree in main.gd
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Passes the player to the stat screen to fill in the values
func populate_stats(player:Player)->void:
	statsScreen.populate(player)

func set_score(score:int) -> void:
	scoreLabel.text = str(score)


func set_time(time:int):
	timeLabel.text = time_to_str(time)


func time_to_str(time:int) -> String:
	var minutes = time / 60
	var seconds = time % 60
	var str_time = "%02d:%02d" % [minutes, seconds]
	return str_time

func akn_new_highscore(former_score:int) -> void:
	akn_score.visible = true
	before_cont.show_score(former_score)
	before_cont.visible = true


func akn_new_besttime(former_time:int) -> void:
	akn_time.visible=true
	before_cont.show_time(former_time)
	before_cont.visible = true

func handle_score_display(former_score:int,new_score:int,former_time:int,new_time:int) -> void:
	set_score(new_score)
	set_time(new_time)
	if new_score > former_score:
		akn_new_highscore(former_score)
	if new_time > former_time:
		akn_new_besttime(former_time)

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_pressed("Escape") and visible:
		get_tree().paused = false
		TimeManager.set_time_scale(1.0)
		get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")
	if Input.is_action_pressed("Enter"):
		Globals.game.restart()


func _on_StatsButton_pressed() -> void:
	statsScreen.popup_centered()
