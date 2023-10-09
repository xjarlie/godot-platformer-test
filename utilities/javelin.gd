extends Area2D

var charge = 0;
@export var max_charge = 20;
@export var shoot_speed = 2000;

var velocity = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func release(crg: int, direction: Vector2, pos: Vector2):
	charge = crg;
	velocity = shoot_speed * direction;
	rotation = direction.angle();
	position = pos;
	
func _physics_process(delta):
	print(charge, position);
	if charge != 0:
		position += velocity * delta;
		charge -= 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
