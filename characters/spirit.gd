extends CharacterBody2D

@export var platform_scene: PackedScene;

var acceleration = 5000;
var max_speed = 1000;
var high_max_speed = 4000;

enum STATES {MOVE, STATIC}
var state: STATES = STATES.MOVE;

var touching_mouse = false;

var gameState = {
	"leftAction": "platform"
}

func _ready():
	$MoonPlatform.hide();
	$MoonPlatform.get_node("CollisionShape2D").disabled = true;

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
	
			if (velocity.length() > actual_max):
				velocity = velocity.normalized() * actual_max;
				
			if ((mouse - position).length() < 100 && !Input.is_action_pressed("left_click")):
				velocity = (get_global_mouse_position() - position) * 10;
			
		else:
			velocity = (get_global_mouse_position() - position) * 10;
			pass;
			
		
		move_and_slide()

func _process(delta):
	if (Input.is_action_pressed("left_click")):
		if (gameState.leftAction == "platform"):
			if (touching_mouse):
				state = STATES.STATIC;
			
				$MoonPlatform.show();
				$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", false);
				$Sprite2D.hide();
			
	if (Input.is_action_just_released("left_click")):
		if (gameState.leftAction == "platform"):
			state = STATES.MOVE;
			
			$MoonPlatform.hide();
			$MoonPlatform.get_node("CollisionShape2D").set_deferred("disabled", true);
			$Sprite2D.show();

func _on_mouse_entered():
	touching_mouse = true;


func _on_mouse_exited():
	touching_mouse = false;
