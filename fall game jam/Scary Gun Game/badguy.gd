extends Area2D

var speed = 300
var movement_type = 0  # 0: left to right, 1: right to left, 2: left to middle, 3: right to middle, 4: top to bottom, 5: bottom to top, 6: custom movement
var direction = 1  # 1 for original direction, -1 for turned around
var target_position = null  # for behaviors 2, 3, 4, and 5
var animation_sets = ["DangerTarget", "MediumTarget", "RareTarget", "EasyTarget"]
var is_paused = false  # Variable to track if the movement is paused
@export var target_type: String = ""

var ammo

func _ready():
	set_process_input(true)
	
	if target_type != "":
		$AnimatedSprite2D.play(target_type)

	if target_type == "EasyTarget":
		movement_type = randi() % 4  # Movement types 0-3
	elif target_type != "EasyTarget":  # Ensures we spawn non-EasyTargets (Medium, Rare)
		movement_type = 4 + randi() % 8  # Movement types 4-11
		

	# Set spawn points based on movement type
	match movement_type:
		0:  # Bottom to top
			position = Vector2(100 + randi() % (int(get_viewport_rect().size.x) - 200), get_viewport_rect().size.y)
			z_index = 35
			speed = -300
			target_position = position.y - 300
		1:  # layer 1
			position = Vector2(100 + randi() % (int(get_viewport_rect().size.x) - 200), 780)  # Start at height 780
			z_index = 25  # Set the z-index
			speed = 300  # Set the speed for this movement type
			target_position = position.y - 250  # Set target position to 30 units above spawn point
		2:
			position = Vector2(100 + randi() % (int(get_viewport_rect().size.x) - 200), 500)  # Start at height 780
			z_index = 15  # Set the z-index
			speed = 300  # Set the speed for this movement type
			target_position = position.y - 250  # Set target position to 30 units above spawn point
		3:
			position = Vector2(100 + randi() % (int(get_viewport_rect().size.x) - 200), 250)  # Start at height 780
			z_index = 5  # Set the z-index
			speed = 300  # Set the speed for this movement type
			target_position = position.y - 150  # Set target position to 30 units above spawn point
		4:  # Left to right
			position = Vector2(0, 730)
			z_index = 35
			speed = 550
		5:  # Left to right
			position = Vector2(0, 530)
			z_index = 25
			speed = 475
		6:  # Left to right
			position = Vector2(0, 250)
			z_index = 15
			speed = 400
		7:  # Left to right
			position = Vector2(0, 100)
			z_index = 5
			speed = 325
		8:  # Left to right
			position = Vector2(get_viewport_rect().size.x, 730)
			z_index = 35
			speed = -550
		9:  # Left to right
			position = Vector2(get_viewport_rect().size.x, 530)
			z_index = 25
			speed = -475
		10:  # Left to right
			position = Vector2(get_viewport_rect().size.x, 250)
			z_index = 15
			speed = -400
		11:  # Left to right
			position = Vector2(get_viewport_rect().size.x, 100)
			z_index = 5
			speed = -325

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			match target_type:
				"EasyTarget":
					get_tree().call_group("player", "add_points", 1)
					get_tree().call_group("player", "change_combo", 1)
					$AudioStreamPlayer.play()
				"MediumTarget":
					get_tree().call_group("player", "add_points", 2)
					get_tree().call_group("player", "change_combo", 1)
					$AudioStreamPlayer.play()
				"DangerTarget":
					get_tree().call_group("player", "add_points", 3)
					get_tree().call_group("player", "change_combo", 1)
					$AudioStreamPlayer.play()
				"RareTarget":
					get_tree().call_group("player", "add_points", 10)
					get_tree().call_group("player", "change_combo", 1)
					$AudioStreamPlayer.play()
			$AudioStreamPlayer.play()

			
			queue_free()  # Remove the target once it's shot


func _process(delta):
	# Don't process movement if paused
	if is_paused:
		return
	
	match movement_type:
		0:  # move from bottom to middle, then stop, and turn back
			if direction == 1 and position.y > target_position:
				position.y += speed * delta
			elif direction == 1:  # Reached the middle
				$EasyTargetStall.start()  # Start the EasyTargetStall timer and pause movement
				is_paused = true
				direction = -1
			elif direction == -1:
				position.y -= speed * delta
		1:  # Custom movement behavior
			if direction == 1 and position.y > target_position:
				position.y -= speed * delta  # Move up towards target
			elif direction == 1:  # Reached the target position
				$EasyTargetStall.start()  # Start the EasyTargetStall timer and pause movement
				is_paused = true  # Pause movement
				direction = -1  # Prepare to turn around
			elif direction == -1:
				position.y += speed * delta  # Move back down
		2:  # Custom movement behavior
			if direction == 1 and position.y > target_position:
				position.y -= speed * delta  # Move up towards target
			elif direction == 1:  # Reached the target position
				$EasyTargetStall.start()  # Start the EasyTargetStall timer and pause movement
				is_paused = true  # Pause movement
				direction = -1  # Prepare to turn around
			elif direction == -1:
				position.y += speed * delta
		3:  # Custom movement behavior
			if direction == 1 and position.y > target_position:
				position.y -= speed * delta  # Move up towards target
			elif direction == 1:  # Reached the target position
				$EasyTargetStall.start()  # Start the EasyTargetStall timer and pause movement
				is_paused = true  # Pause movement
				direction = -1  # Prepare to turn around
			elif direction == -1:
				position.y += speed * delta
		4:  # move from left to right
			position.x += speed * delta
		5:  # move from left to right
			position.x += speed * delta
		6:  # move from left to right
			position.x += speed * delta
		7:  # move from left to right
			position.x += speed * delta
		8:  # move from left to right
			position.x += speed * delta
		9:  # move from left to right
			position.x += speed * delta
		10:  # move from left to right
			position.x += speed * delta
		11:  # move from left to right
			position.x += speed * delta

	# Get the size of the current frame of the AnimatedSprite2D
	var sprite = $Sprite2D
	var sprite_width = sprite.texture.get_size().x
	var sprite_height = sprite.texture.get_size().y
	
	# Remove enemy if it leaves the screen
	if position.x < -sprite_width or position.x > get_viewport_rect().size.x + sprite_width or position.y < -sprite_height or position.y > get_viewport_rect().size.y + sprite_height:
		if target_type == "MediumTarget":
			get_tree().call_group("player", "drop_combo")
		if target_type == "DangerTarget":
			get_tree().call_group("player", "change_lives", -15)
			get_tree().call_group("player", "drop_combo")
		
		queue_free()

# Timer callback to resume movement after 2 seconds
func _on_easy_target_stall_timeout():
	is_paused = false
