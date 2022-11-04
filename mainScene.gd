extends Node2D

var bomb = load("res://prefabs/bomb.tscn")
var apple = load("res://prefabs/apple.tscn")
var orange = load("res://prefabs/orange.tscn")
var grapes = load("res://prefabs/grapes.tscn")
var watermelon = load("res://prefabs/watermelon.tscn")
var pineapple = load("res://prefabs/pineapple.tscn")
var cherry = load("res://prefabs/cherry.tscn")
var strawberry = load("res://prefabs/strawberry.tscn")
var banana = load("res://prefabs/banana.tscn")

var rIndex:int = 9

const saveFilePath = "user://savedata.save"

var highscore:int = 0
var score:int = 0
onready var scoreText = get_node("scoreText")
onready var highscoreText =get_node("bestScore")

# Called when the node enters the scene tree for the first time.
func _ready():
	scoreText.text = "SCORE: " + str (score)
	LoadHighscore()
	pass # Replace with function body.


func SpawnSpawnables(index:int):
	if(index == 0):
		add_child(bomb.instance())
		pass
	if(index == 1):
		add_child(cherry.instance())
		pass
	if(index == 2):
		add_child(strawberry.instance())
		pass
	if(index == 3):
		add_child(banana.instance())
		pass
	if(index == 4):
		add_child(apple.instance())
		pass
	if(index == 5):
		add_child(orange.instance())
		pass
	if(index == 6):
		add_child(pineapple.instance())
		pass
	if(index == 7):
		add_child(watermelon.instance())
		pass
	if(index == 8):
		add_child(grapes.instance())
		pass
	if(index >= 9):
		add_child(bomb.instance())
		pass
	pass

var v:int = 35
func _on_Timer_timeout():
	randomize()
	if (score <= (v*2)):
		SpawnSpawnables(randi()%rIndex)
		$Timer.wait_time = 0.9
	elif (score >(v*2) and score<=(v*3)):
		SpawnSpawnables(randi()%(rIndex+1))
		$Timer.wait_time = 0.8
	elif (score >(v*3) and score<=(v*4)):
		SpawnSpawnables(randi()%(rIndex+2))
		$Timer.wait_time = 0.7
	elif (score >(v*4) and score<=(v*5)):
		SpawnSpawnables(randi()%(rIndex+3))
		$Timer.wait_time = 0.6
	elif (score >(v*5) and score<=(v*6)):
		SpawnSpawnables(randi()%(rIndex+4))
		$Timer.wait_time = 0.5
	elif (score >(v*6) and score<=(v*7)):
		SpawnSpawnables(randi()%(rIndex+5))
		$Timer.wait_time = 0.4
	elif (score >(v*7)):
		SpawnSpawnables(randi()%(rIndex+5))
		$Timer.wait_time = 0.3
	pass # Replace with function body.

func SaveHighscore():
	var saveData = File.new()
	saveData.open(saveFilePath, File.WRITE)
	saveData.store_var(highscore)
	saveData.close()
	pass

func LoadHighscore():
	var saveData = File.new()
	if saveData.file_exists(saveFilePath):
		saveData.open(saveFilePath, File.READ)
		highscore = saveData.get_var()
		saveData.close()
		pass
	pass

func _on_playerBasket_scoreChanged(newScore):
	score = newScore
	scoreText.text = "SCORE: " + str (score)
	if(score > highscore):
		highscore = score
		SaveHighscore()
		highscoreText.text = "BEST SCORE: " + str(highscore)
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
