extends CharacterBody2D

@export var gravity: float = 5000.0  # Gravity force 
@export var jump_force: float = -1200.0  # Jump height
@export var max_fall_speed: float = 1800.0  # Limit fall speed
@export var speed: float = 8.0  # Player's movement speed
var can_double_jump: bool = false  # Tracks if player can jump again

func _physics_process(delta):
	if $AnimatedSprite2D.animation == "hurt":
		return  # Stop updating animations if "hurt" is playing
	# Apply gravity to the player's vertical velocity
	velocity.y += gravity * delta
	
	# Limits the player's fall speed to prevent excessive downward acceleration
	if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed  # Falling limit
			
	# Checks if the player is on the ground
	if is_on_floor():
		can_double_jump = true  # Resets double jump on landing
		
		# If the game hasn't started it keeps the player idle
		if not get_parent().game_start:
			$AnimatedSprite2D.play("idle")
		else:
			$RunCol.disabled = false #
			velocity.y = speed  #  Ensures player moves forward
			
			 # Checks if the player presses the jump button
			if Input.is_action_just_pressed("ui_accept"):
				jump() # Perform jump action
			else:
				$AnimatedSprite2D.play("run") # Play running animation
	else:
		# If in the air, checks for double jump input
		if Input.is_action_just_pressed("ui_accept") and can_double_jump:
			jump() # Perform double jump
			can_double_jump = false  # Only allows one mid-air jump
			
		# Play jumping animation while in the air
		$AnimatedSprite2D.play("jump")
	 
	move_and_slide()

func jump():
	velocity.y = jump_force  # Apply jump force to the player's velocity
	$JumpSound.play()  # Play jump sound effect
	move_and_slide()
