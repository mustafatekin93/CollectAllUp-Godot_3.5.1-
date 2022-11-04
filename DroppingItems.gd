extends KinematicBody2D

var velocity = Vector2(0,0)
var startPosition = Vector2(0,-170)

export var minSpeed:float
export var maxSpeed:float

func _ready():
	randomize()
	startPosition.x = rand_range(-70,70)
	velocity.y = rand_range(minSpeed,maxSpeed)
	position = startPosition
	pass # Replace with function body.

func _process(delta):
	position += velocity * delta
	#move_and_slide(velocity)
	
	if(position.y > 150):
		queue_free()
		
	pass
