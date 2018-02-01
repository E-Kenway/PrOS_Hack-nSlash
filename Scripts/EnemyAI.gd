extends KinematicBody2D 

export var health = 100 setget set_health, get_health 
export var damage = 10
export var enemyTypes = ["Simple", "Jumper", "Range"]
export var coinsDrop = 10
export var attackRange = 20
export var speed = 100
const JUMP_FORCE = 1000
var velocity = Vector2()
const GRAVITY = 981.0
var motion

func _fixed_process(delta):
	var rootViewportSize = Vector2(Globals.get("display/width"),Globals.get("display/height"))
	var player = get_node("../../Player")
	var playerPos = player.get_pos()
	var playerColl = player.get_node("CollisionShape2D")
	var enemy = self
	var enemyPos = enemy.get_pos()
	var playerIsDetected = false
	var healthBar = get_node("EnemyHealthBar/TextureProgress")
	
	healthBar.set_value(self.health)
	
	if(enemyPos <= rootViewportSize):
		playerIsDetected = true
	
	if(playerIsDetected == true):
		if(is_colliding() == false):
			velocity.y += delta * GRAVITY
			motion = delta * velocity
			move(motion)
			#print("goes down")
		if((playerPos.x + attackRange + 80) < enemyPos.x ):
			velocity.x -= delta * speed
			motion = delta * velocity
			var n = get_collision_normal()
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
			#print("goes left")
		if((playerPos.x - attackRange - 80) > enemyPos.x ):
			velocity.x += delta * speed
			motion = delta * velocity
			var n = get_collision_normal()
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
			#print("goes right")
	
	
	if(self.health == 0):
		queue_free()
	
	
	
	
	"""if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)"""

func _ready():
	set_fixed_process(true)

func set_health(value):
	health = value

func get_health():
	return health