extends Area2D

@export var force_field_radius = 32;
var force_field_strength = 300;

var player_inside = false;
var player_body: CharacterBody2D;
var player_action = "down";
@export var damage_done = 10;

var damage_waiting = false;

var spirit_inside = false;
var spirit_body: CharacterBody2D;

var disabled = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = force_field_radius;
	$Sprite2D.scale.x = force_field_radius / 32 * 0.22;
	$Sprite2D.scale.y = $Sprite2D.scale.x;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if (disabled):
		return;
	if (player_inside):
		var disp_to_player = (player_body.position - position);
		#const C = 10000;
		#var dist_to_player = disp_to_player.length()
		#var magnitude = (-1 * (C)) / (dist_to_player * dist_to_player);
		#var direction = disp_to_player.normalized();
		#player_body.velocity += direction * magnitude;
		#player_body.velocity.bounce(disp_to_player.normalized());
		print(player_body.velocity);
		var final_v = disp_to_player.normalized() * force_field_strength;
		player_body.velocity = lerp(player_body.velocity, final_v, 0.5);
		if (player_body.position.y > position.y):
			player_body.velocity.y += 200;
			if !damage_waiting:
				damage_then_wait();
			player_action = "down";
		else: 
			get_tree().get_first_node_in_group("spirit").regen_stamina(9999999999)
			player_body.velocity.y -= 500;
			if !damage_waiting:
				damage_then_wait();
			player_action = "jump";

	if (spirit_inside):
		var disp_to_spirit = (spirit_body.position - position);
		#spirit_body.velocity = -spirit_body.velocity;
		

func _on_body_entered(body):
	if (body.is_in_group("player")):
		player_inside = true;
		player_body = body;
	elif body.is_in_group("spirit"):
		spirit_body = body;
		spirit_inside = true;

func damage_then_wait():
	#await get_tree().create_timer(0.3).timeout;
	#if (player_inside):
		#player_body.damage(10);
	player_body.damage(10);
	$DamageTimer.start();
	damage_waiting = true;

func _on_body_exited(body):
	if (body.is_in_group("player")):
		player_inside = false;
		
		if (player_action == "jump"):
			#$DisableTimer.start();
			#disable();
			pass;
	elif body.is_in_group("spirit"):
		spirit_inside = false;

func disable():
	disabled = true;
	$CollisionShape2D.set_deferred("disabled", true);
	$ColorRect.color = Color(1, 0, 0);
	
func enable():
	disabled = false;
	$CollisionShape2D.set_deferred("disabled", false);
	$ColorRect.color = Color(1, 1, 0);

func _on_disable_timer_timeout():
	enable();


func _on_damage_timer_timeout():
	damage_waiting = false;
	if (player_inside):
		damage_then_wait();
