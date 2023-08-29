extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_SPEED = 900.0
@export_range(0.0, 1.0) var friction = 0.1;
@export_range(0.0, 1.0) var acceleration = 0.25;
@export var gravity = 3000;

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum states {IDLE, RUN, JUMP};

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		#velocity.x = direction * SPEED
		velocity.x = lerp(velocity.x, direction * SPEED, acceleration);
	else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if velocity.x > 0:
		$Sprite2D.set_flip_h(false);
	elif velocity.x < 0:
		$Sprite2D.set_flip_h(true);
		
	move_and_slide()
	
	

