extends CharacterBody2D

signal death;

@export var SPEED = 300.0
@export var JUMP_SPEED = 900.0
@export_range(0.0, 1.0) var friction = 0.4;
@export_range(0.0, 1.0) var acceleration = 0.25;
@export var gravity = 3000;
@export var javelin: PackedScene;
var javelin_charging = false;
var javelin_charge = 0;

@export var max_health = 100;
var health = max_health;

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum states {IDLE, RUN, JUMP};
var last_on_floor = 0;
var mercy_frames = 6;


func begin():
	health = max_health;

func _physics_process(delta):
	# Add the gravity.
	var CURRENT_FRAME = Engine.get_physics_frames();
	if is_on_floor():
		last_on_floor = CURRENT_FRAME;
	else:
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (CURRENT_FRAME < last_on_floor + mercy_frames):
		velocity.y += -JUMP_SPEED
		
	if javelin_charging:
		javelin_charge += 1;

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
		
	move_and_slide();
	resolve_health();

func _process(_delta):
	if (Input.is_action_pressed("move_down") && is_on_floor()):
		$Camera2D.offset.y = lerp($Camera2D.offset.y, 200.0, 0.03);
	else:
		$Camera2D.offset.y = lerp($Camera2D.offset.y, 0.0, 0.03);

func damage(amt: int):
	health -= amt;

func heal(amt: int):
	health += amt;
	
func resolve_health():
	if (health <= 0):
		health = 0;
		die();
	if (health > max_health):
		health = max_health;

func die():
	print("dead");
	death.emit();

func is_on_solid_ground():
	return (is_on_floor() && get_last_slide_collision() && get_last_slide_collision().get_collider().get_groups().has("solid_platform"));
	
func begin_javelin():
	javelin_charging = true;
	
	
func release_javelin():
	var instance = javelin.instantiate();
	get_tree().get_root().add_child(instance);
	var direction_to_mouse = (get_global_mouse_position() - position).normalized();
	instance.release(javelin_charge, direction_to_mouse, position);
	javelin_charging = false;
	javelin_charge = 0;
	print("jav end");
