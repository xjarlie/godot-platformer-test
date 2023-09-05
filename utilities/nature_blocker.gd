extends Area2D

@export var force_field_radius = 32;
var force_field_strength = 3;

var player_inside = false;
var player_body: CharacterBody2D;
var player_velocities = Array();

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = force_field_radius;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if (player_inside):
		var disp_to_player = (player_body.position - position);
		#const C = 10000;
		#var dist_to_player = disp_to_player.length()
		#var magnitude = (-1 * (C)) / (dist_to_player * dist_to_player);
		#var direction = disp_to_player.normalized();
		#player_body.velocity += direction * magnitude;
		player_body.velocity.bounce(disp_to_player.normalized());
		print(player_body.velocity);

func _on_body_entered(body):
	if (body.is_in_group("player")):
		player_inside = true;
		player_body = body;



func _on_body_exited(body):
	if (body.is_in_group("player")):
		player_inside = false;
