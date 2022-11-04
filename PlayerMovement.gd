extends KinematicBody2D

var moveSpeed = 200
var velocity = Vector2()

var fingerPoint = Vector2()
var startPoint = Vector2()

var drag:bool = false

var hitCounter:int = 0

var multiplier:int = 1
var pitchCounter:float = 0.9

export var expParticle : PackedScene
export var collectParticle : PackedScene

export (Texture) var muteTexture
export (Texture) var unmuteTexture

var explotionSFX:Array
onready var explotion_1 = preload("res://SFX/explosion (1).wav")
onready var explotion_2 = preload("res://SFX/explosion (2).wav")
onready var explotion_3 = preload("res://SFX/explosion (3).wav")

onready var collectSound = load("res://SFX/pickUp.wav")

const saveFilePath = "user://savedata.save"
var highscore:int = 0
var score = 0
var volume = -20
var mute = false

signal scoreChanged(newScore)
# Called when the node enters the scene tree for the first time.
func _ready():
	explotionSFX = [explotion_1,explotion_2,explotion_3]
	LoadHighscore()
	pass # Replace with function body.

func PlaySound(var audio,var pitch,var vol):
	var musicPlayer = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(musicPlayer)
	var sound = audio
	musicPlayer.set_stream(sound)
	musicPlayer.volume_db = vol
	musicPlayer.pitch_scale = pitch
	musicPlayer.play()
	pass

func PlayRandomExplotionSound():
	randomize()
	var index = randi()%(explotionSFX.size())
	PlaySound(explotionSFX[index],1,volume)
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			fingerPoint = event.position
			startPoint = position
			drag = true
		else:
			drag = false
			position = Vector2(position.x,130)
		pass
	elif (event is InputEventMouseMotion and drag):
		position.x = ((fingerPoint.x - event.position.x) * -0.75) + startPoint.x
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	IsMuted()
	CheckMultiplier()
	if drag:
		#var tempPos = (fingerPoint.x  - get_viewport().get_mouse_position().x)*-1
		#position = lerp (position, Vector2(tempPos,130),0.25)
		#tempPos = fingerPoint.x
		#position = lerp(position,Vector2(get_global_mouse_position().x,130),0.25)
		pass
		
	move_and_slide(velocity)
	CheckValidPosition()
	CheckHitCounter()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if(collision.collider.is_in_group("fruit")):
			AddMultiplier()
			position.y = 130
			
			pitchCounter += 0.1
			if(pitchCounter >= 3):
				pitchCounter = 3
			PlaySound(collectSound,pitchCounter,volume)
			
			var _particle = collectParticle.instance()
			_particle.position = collision.collider.global_position
			_particle.rotation = collision.collider.global_rotation
			_particle.emitting = true
			get_tree().current_scene.add_child(_particle)
				
			score += multiplier
			emit_signal("scoreChanged",score)
			if(score > highscore):
				highscore = score
				SaveHighscore()
			collision.collider.queue_free()
			pass
		if(collision.collider.is_in_group("bomb")):
			position.y = 130
			ResetMultiplier()
			PlayRandomExplotionSound()
			var _particle = expParticle.instance()
			_particle.position = collision.collider.global_position
			_particle.rotation = collision.collider.global_rotation
			_particle.emitting = true
			get_tree().current_scene.add_child(_particle)
			Input.vibrate_handheld(200)
			hitCounter += 1
			collision.collider.queue_free()
			pass
		pass
	pass
	
func CheckValidPosition():
	if(position.x <= -60):
		position.x = -60
	elif(position.x  >= 60):
		position.x = 60
	pass

func CheckHitCounter():
	if(hitCounter == 0):
		$"../hp1".modulate = Color.white
		$"../hp2".modulate = Color.white
		$"../hp3".modulate = Color.white
		pass
	elif(hitCounter == 1):
		$"../hp1".modulate = Color.black
		$"../hp2".modulate = Color.white
		$"../hp3".modulate = Color.white
		pass
	elif(hitCounter == 2):
		$"../hp1".modulate = Color.black
		$"../hp2".modulate = Color.black
		$"../hp3".modulate = Color.white
		pass
	elif(hitCounter == 3):
		$"../hp1".modulate = Color.black
		$"../hp2".modulate = Color.black
		$"../hp3".modulate = Color.black
		Input.vibrate_handheld(400)
		PlayRandomExplotionSound()
		$"../gameOverText".visible = true
		$"../bestScore".visible = true
		$"../bestScore".text = "BEST SCORE: " + str(highscore)
		$"../yourScore".visible = true
		$"../yourScore".text = "YOUR SCORE: " + str(score)
		$"../Button".visible = true
		queue_free()		
		pass
	pass
	
func CheckMultiplier():
	var value = $"../Multiplier/TextureProgress".value
	if( value >=0 and value < 2):
		$"../Multiplier/TextureProgress/Label".text = "x1"
		multiplier = 1
		pitchCounter = 1
		Engine.time_scale = 1
		pass
	elif(value >=2 and value < 4):
		$"../Multiplier/TextureProgress/Label".text = "x2"
		multiplier = 2
		pitchCounter = 1.15
		Engine.time_scale = 1.15
		pass
	elif(value >=4 and value < 6):
		$"../Multiplier/TextureProgress/Label".text = "x4"
		multiplier = 4
		pitchCounter = 1.3
		Engine.time_scale = 1.30
		pass
	elif(value >=6 and value < 8):
		$"../Multiplier/TextureProgress/Label".text = "x8"
		multiplier = 8
		pitchCounter = 1.45
		Engine.time_scale = 1.50
		pass
	elif(value >=8 and value < 10):
		$"../Multiplier/TextureProgress/Label".text = "x16"
		multiplier = 16
		pitchCounter = 1.6
		Engine.time_scale = 2
		pass	

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
		highscore = saveData.get_var(0)
		saveData.close()
		pass
	pass
	
func _on_MultiplierEnd_body_entered(body):
	pass # Replace with function body.

func _on_muteButton_pressed():
	Options.mute = !Options.mute
	pass # Replace with function body.

func IsMuted():
	if(Options.mute):
		volume = -80
		$"../muteButton".texture_normal = muteTexture
		pass
	else:
		volume = -2
		$"../muteButton".texture_normal = unmuteTexture
		pass
	pass


func _on_multiplierTimer_timeout():
	$"../Multiplier/TextureProgress".value -= 0.15
	pass # Replace with function body.

func AddMultiplier():
	$"../Multiplier/TextureProgress".value += 2
	pass
	
func ResetMultiplier():
	$"../Multiplier/TextureProgress".value = 0
	pass
