extends Node2D

const saveFilePath = "user://savedata.save"
var highscore:int = 0
var counter:int = 0

func _ready():
	$gameTitle/titleAnimationPlayer.play("gameTitle")
	LoadHighscore()
	$scoreText.text = "HIGHSCORE: " + str(highscore)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			counter += 1
			if(counter >= 10):
				$resetScore.visible = true
		pass

func _on_playButton_pressed():
	get_tree().change_scene("res://mainScene.tscn")
	pass # Replace with function body.
	
func LoadHighscore():
	var saveData = File.new()
	if saveData.file_exists(saveFilePath):
		saveData.open(saveFilePath, File.READ)
		highscore = saveData.get_var()
		saveData.close()
		pass
	pass

func SaveHighscore():
	var saveData = File.new()
	saveData.open(saveFilePath, File.WRITE)
	saveData.store_var(highscore)
	saveData.close()
	pass
	
func _on_resetScore_pressed():
	highscore = 0
	SaveHighscore()
	$scoreText.text = "HIGHSCORE: " + str(highscore)
	pass # Replace with function body.


func _on_optionsButton_pressed():
	$playButton.visible = false
	$optionsButton.visible = false
	$gameTitle.text = "OPTIONS"
	$backButton.visible = true
	$SFX.visible = true
	pass # Replace with function body.


func _on_backButton_pressed():
	$playButton.visible = true
	$optionsButton.visible = true
	$gameTitle.text = "COLLECT ALL UP"
	$backButton.visible = false
	$SFX.visible = false
	pass # Replace with function body.
