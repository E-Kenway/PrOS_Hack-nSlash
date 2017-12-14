xtends RigidBody2D

var speed = 100;
var vel = Vector2()

func _ready():
	set_process(true)

func _process(delta):
	set_linear_velocity(Vector2(0,0))
	if (Input.is_key_pressed(KEY_D)):
		set_linear_velocity(Vector2(speed,0))
	elif(Input.is_key_pressed(KEY_A)):
		set_linear_velocity(Vector2(-speed,0))
	elif (Input.is_key_pressed(KEY_SPACE)):
		set_linear_velocity(Vector2(0,-speed))
	
	//after moving up player doesnt fall down anymore
