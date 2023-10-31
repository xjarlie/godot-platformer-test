extends Node2D

@export var fixedPoint: Vector2;
var current_angle: float = PI/3;
var angular_velocity: float = 0.0;
var radius: float = 0.0;

var MAX_ANGULAR_SPEED = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	fixedPoint = $FixedPoint.position;
	radius = $Area2D/CollisionShape2D.shape.radius;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_angle = clamp(current_angle, 0, 2*PI);
	$Sprite2D.global_rotation = current_angle;
	
func _physics_process(delta):
	var angle_from_rest: float = current_angle - PI/2;
	if (round(angle_from_rest*10) != 0):		
		angular_velocity += lerp(angular_velocity, -MAX_ANGULAR_SPEED*sign(angle_from_rest), 0.1);
		current_angle += angular_velocity * delta;

func add_velocity(v: Vector2):
	var horiz: float = v.x;
	var ang_v = horiz;
	angular_velocity += ang_v;


func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		print(body.velocity);
		add_velocity(body.velocity);
