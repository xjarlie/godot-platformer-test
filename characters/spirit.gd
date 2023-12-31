extends CharacterBody2D

@export var platform_scene: PackedScene;

signal javelin_start;
signal javelin_release;

var acceleration = 5000;
var max_speed = 1000;
var high_max_speed = 4000;

enum STATES {MOVE, STATIC}
var state: STATES = STATES.MOVE;

var touching_mouse = false;

const STARTING_STAMINA = 200;
var stamina = STARTING_STAMINA;

@export var slash_damage = 10;
var slash_in_progress = false;

var gameState = {
	"left_action": "platform",
	"right_action": "orb"
}

func _ready():
	begin();

func begin():
	$SlashSprite.hide();
	$MoonPlatform.hide();
	$MoonPlatform.get_node("CollisionShape2D").disabled = true;
	position = Vector2.ZERO;
	stamina = STARTING_STAMINA;

func _physics_process(delta):
	var mouse = get_global_mouse_position();
	var direction_to_mouse = (mouse - position);
	if (gameState.left_action == "platform"):
		# PLATFORM MECHANICS
		
		if (state == STATES.MOVE):	
			
			if (touching_mouse == false):
				var extra = 1;
				var actual_max = max_speed;
			
			
				if (Input.is_action_pressed("left_click")):
					#extra = 2;
					actual_max = high_max_speed;
		
				velocity += direction_to_mouse * acceleration * delta * extra;
				#velocity = lerp(velocity, direction * 1000 * delta, acceleration);
			
				var next_frame_pos = position + velocity;
				var next_direction = (mouse - next_frame_pos);
				var will_cross_x = (next_direction.x * direction_to_mouse.x) > 0;
				var will_cross_y = (next_direction.y * direction_to_mouse.y) > 0;
				if (will_cross_x && will_cross_y):
					velocity = Vector2.ZERO;
					position = mouse;
		
				if (velocity.length() > actual_max):
					velocity = velocity.normalized() * actual_max;
					
				if ((mouse - position).length() < 100 && !Input.is_action_pressed("left_click")):
					velocity = (get_global_mouse_position() - position) * 10;
				
			else:
				velocity = direction_to_mouse * 10;
				pass;

			move_and_slide()
		elif (state == STATES.STATIC):
			stamina -= 2;
	elif (gameState.left_action == "slash"):
		# SLASH ATTACK MECHANICS
		
		position = get_tree().get_first_node_in_group("player").position;
		direction_to_mouse = (mouse - position);
		if (Input.is_action_just_pressed("left_click")):
			var mouse_angle = direction_to_mouse.angle();
			print("attack", mouse_angle);
			
			var attack_angles = [
				-PI, -3*PI/4, -PI/2, -PI/4, 0, PI/4, PI/2, 3*PI/4, PI
			]
			var current = attack_angles[0];
			for i in 9:
				if abs(mouse_angle - attack_angles[i]) < abs(mouse_angle - current):
					current = attack_angles[i];
			
			var rounded_angle = current;
			print(rounded_angle);
			$SlashArea.rotation = rounded_angle;
			$SlashSprite.rotation = rounded_angle - PI/8;
			rotate_slash_sprite(PI/4, 0.1);
			
			# Check for damage dealt
			var bodies = $SlashArea.get_overlapping_bodies();
			print(bodies);
			for body in bodies:
				if (body.is_in_group("goon")):
					body.damage(slash_damage);
			
		else:
			slash_in_progress = false;
	
	if (Input.is_action_just_pressed("right_click")):
		if (gameState.right_action == "javelin"):
			javelin_start.emit();
	if (Input.is_action_just_released("right_click")):
		if (gameState.right_action == "javelin"):
			javelin_release.emit();

func _process(delta):
	#print(stamina);
	
	if (state == STATES.MOVE):
		#$TrailEmitter.process_material.direction = velocity.angle();
		pass;
	
	if (gameState.left_action != "platform"):
		#hide();
		pass;
	else:
		show();
	
	if (Input.is_action_pressed("left_click")):
		if (gameState.left_action == "platform"):
			if (touching_mouse && stamina > 0):
				state = STATES.STATIC;

				$MoonPlatform.show();
				$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", false);
				$AnimatedSprite2D.update_animation("spirit-to-platform");
			
			if (state == STATES.STATIC):
				if (stamina < -5):
					state = STATES.MOVE;
			
					$MoonPlatform.hide();
					$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", true);
					$AnimatedSprite2D.update_animation("platform-to-spirit");
			
	if (Input.is_action_just_released("left_click")):
		if (gameState.left_action == "platform"):
			state = STATES.MOVE;
			
			$MoonPlatform.hide();
			$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", true);
			$AnimatedSprite2D.update_animation("platform-to-spirit");

func regen_stamina(amt):
	if (stamina + amt > STARTING_STAMINA):
		stamina = STARTING_STAMINA;
	else:
		stamina += amt;

func _on_mouse_entered():
	touching_mouse = true;


func _on_mouse_exited():
	touching_mouse = false;

var slash_sprite_rotating = false;
func rotate_slash_sprite(total_amount, time):
	if (slash_sprite_rotating):
		return;
		
	const INTERVAL = 0.01;
	var repeats = round(time / INTERVAL);
	var amount = total_amount / repeats;
	
	slash_sprite_rotating = true;
	$SlashSprite.show();
	for i in range(0, repeats):
		$SlashSprite.rotate(amount);
		await get_tree().create_timer(INTERVAL).timeout;
	$SlashSprite.hide();
	slash_sprite_rotating = false;
