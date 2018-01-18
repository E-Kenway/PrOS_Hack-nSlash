extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	
func _process(delta):
	move(Vector2(0,1))