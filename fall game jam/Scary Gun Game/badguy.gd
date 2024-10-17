extends Area2D

var speed = 200

func _ready():
	set_process_input(true)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("BANG!")
			get_tree().call_group("score", "add_points", 1) #call add_points to script in group 'score'
			queue_free()  #die

func _process(delta):
	#move across the screen
	position.x += speed * delta 
	
	var sprite = $Sprite2D
	var sprite_width = sprite.texture.get_size().x
	
	#clear enemy if it leaves the screen
	if position.x < -sprite_width or position.x > get_viewport_rect().size.x + sprite_width:
		queue_free()

func _on_attack_timer_timeout():
	print("AGONY!!!")
	get_tree().call_group("score", "change_lives", -1)
	queue_free()
