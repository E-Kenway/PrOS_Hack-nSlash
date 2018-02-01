extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	var enemys = get_node("../Enemies")
	var enemy = enemys.get_children()
	var dam = 1
	
	for i in enemy:
		if(i != null):
			var enemyHealth = i.health
			if(self.get_pos().x + 120 >= i.get_pos().x && i.health >= 0):
				i.health -= dam
		else:
			return
		
	
	