extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_SPEED = 900.0
@export_range(0.0, 1.0) var friction = 0.1;
@export_range(0.0, 1.0) var acceleration = 0.25;
@export var gravity = 3000;

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum states {IDLE, RUN, JUMP};
var last_on_floor = 0;
var mercy_frames = 5;

func _physics_process(delta):
	# Add the gravity.
	var CURRENT_FRAME = Engine.get_physics_frames();
	if is_on_floor():
		last_on_floor = CURRENT_FRAME;
	else:
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (CURRENT_FRAME < last_on_floor + mercy_frames):
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
	
	

func is_on_ground():
	print(get_slide_collision_count() > 1);
	return true;
		
