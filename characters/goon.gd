extends CharacterBody2D

@export var max_health = 50;
var health;
@export var gravity = 3000;

var starting_pos;

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health;
	starting_pos = position;
	begin();

func begin():
	position = starting_pos;
	show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(health);
	
func _physics_process(delta):
	
	velocity.y = delta * gravity;
	move_and_slide();
	resolve_health();

func resolve_health():
	if (health <= 0):
		health = 0;
		die();
	if (health> max_health):
		health = max_health;


func die():
	print("goon dead");
	health = max_health;
	hide();
	
func damage(amt: int):
	health -= amt;



func _on_body_collision_area_body_entered(body):
	if (body.is_in_group("player")):
		body.damage(10);
