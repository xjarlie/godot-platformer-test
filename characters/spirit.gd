extends CharacterBody2D

@export var platform_scene: PackedScene;

var acceleration = 5000;
var max_speed = 1000;
var high_max_speed = 4000;

enum STATES {MOVE, STATIC}
var state: STATES = STATES.MOVE;

var touching_mouse = false;

const STARTING_STAMINA = 100;
var stamina = STARTING_STAMINA;

var gameState = {
	"left_action": "platform"
}

func _ready():
	begin();

func begin():
	$MoonPlatform.hide();
	$MoonPlatform.get_node("CollisionShape2D").disabled = true;
	position = Vector2.ZERO;
	stamina = STARTING_STAMINA;

func _physics_process(delta):
	
	if (state == STATES.MOVE):
		if (touching_mouse == false):
			var extra = 1;
			var actual_max = max_speed;
			var mouse = get_global_mouse_position();
			var direction = (mouse - position);
			
			if (Input.is_action_pressed("left_click")):
				#extra = 2;
				actual_max = high_max_speed;
	
			velocity += direction * acceleration * delta * extra;
			#velocity = lerp(velocity, direction * 1000 * delta, acceleration);
			
			var next_frame_pos = position + velocity;
			var next_direction = (mouse - next_frame_pos);
			var will_cross_x = (next_direction.x * direction.x) > 0;
			var will_cross_y = (next_direction.y * direction.y) > 0;
			if (will_cross_x && will_cross_y):
				velocity = Vector2.ZERO;
				position = mouse;
	
			if (velocity.length() > actual_max):
				velocity = velocity.normalized() * actual_max;
				
			if ((mouse - position).length() < 100 && !Input.is_action_pressed("left_click")):
				velocity = (get_global_mouse_position() - position) * 10;
			
		else:
			velocity = (get_global_mouse_position() - position) * 10;
			pass;
			
		
		move_and_slide()
	elif (state == STATES.STATIC):
		stamina -= 1;

func _process(delta):
	#print(stamina);
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

func regen_stamina(amt: int):
	if (stamina + amt > STARTING_STAMINA):
		stamina = STARTING_STAMINA;
	else:
		stamina += amt;

func _on_mouse_entered():
	touching_mouse = true;


func _on_mouse_exited():
	touching_mouse = false;
