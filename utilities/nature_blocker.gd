extends Area2D

@export var force_field_radius = 32;
var force_field_strength = 3;

var player_inside = false;
var player_body: PhysicsBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = force_field_radius;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if player_inside:
		#player_body.velocity = -player_body.velocity;
		var body = player_body;
		var direction_to_body: Vector2 = (body.position - position);
		#print(body.position, position, direction_to_body.normalized());
		var target = position + (direction_to_body.normalized() * (force_field_radius * 1.1));
		body.velocity = lerp(body.velocity, direction_to_body, force_field_strength)

func _on_body_entered(body):
	if (body.is_in_group("player")):
		player_inside = true;
		player_body = body;
		#await get_tree().create_timer(0.3).timeout;
		
		#var direction_to_body: Vector2 = (body.position - position);
		#print(body.position, position, direction_to_body.normalized());
		#var target = position + (direction_to_body.normalized() * (force_field_radius * 1.1));
		#body.velocity = -body.velocity;



func _on_body_exited(body):
	if (body.is_in_group("player")):
		player_inside = false;
