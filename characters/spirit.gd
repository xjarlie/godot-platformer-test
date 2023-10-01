extends CharacterBody2D

@export var platform_scene: PackedScene;

var acceleration = 5000;
var max_speed = 1000;
var high_max_speed = 4000;

enum STATES {MOVE, STATIC}
var state: STATES = STATES.MOVE;

var touching_mouse = false;

const STARTING_STAMINA = 200;
var stamina = STARTING_STAMINA;

var gameState = {
	"left_action": "platform",
	"right_action": "orb"
}

func _ready():
	begin();

func begin():
	$MoonPlatform.hide();
	$MoonPlatform.get_node("CollisionShape2D").disabled = true;
	position = Vector2.ZERO;
	stamina = STARTING_STAMINA;

func _physics_process(delta):
	var mouse = get_global_mouse_position();
	var direction_to_mouse = (mouse - position);
	if (gameState.left_action == "platform"):
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
		position = get_tree().get_first_node_in_group("player").position;
		direction_to_mouse = (mouse - position);
		if (Input.is_action_just_pressed("left_click")):
			var mouse_angle = direction_to_mouse.angle();
			print("attack", mouse_angle);
			
			var intervals = [
				0,
				PI/16,
				7*PI/16,
				9*PI/16,
				15*PI/16,
				PI
			];
			var attack_angles = [
				-PI, -3*PI/4, -PI/2, -PI/4, 0, PI/4, PI/2, 3*PI/4, PI
			]
			var current = attack_angles[0];
			for i in 9:
				if abs(mouse_angle - attack_angles[i]) < abs(mouse_angle - current):
					current = attack_angles[i];
			
			var rounded_angle = current;
			print(rounded_angle);

func _process(delta):
	#print(stamina);
	
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
				$Sprite2D.hide();
			
			if (state == STATES.STATIC):
				if (stamina == 0):
					state = STATES.MOVE;
			
					$MoonPlatform.hide();
					$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", true);
					$Sprite2D.show();
			
	if (Input.is_action_just_released("left_click")):
		if (gameState.left_action == "platform"):
			state = STATES.MOVE;
			
			$MoonPlatform.hide();
			$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", true);
			$Sprite2D.show();

func regen_stamina(amt):
	if (stamina + amt > STARTING_STAMINA):
		stamina = STARTING_STAMINA;
	else:
		stamina += amt;

func _on_mouse_entered():
	touching_mouse = true;


func _on_mouse_exited():
	touching_mouse = false;
