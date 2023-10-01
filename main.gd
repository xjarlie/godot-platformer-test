extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	begin();


func begin():
	$Player.position = Vector2(296, 456);
	$Player.begin();
	$Spirit.begin();
	$UI.show();
	$UI.update_left_action($Spirit.gameState.left_action);
	$UI.update_right_action($Spirit.gameState.right_action);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI.update_stamina($Spirit.stamina);
	$UI.update_health($Player.health);
	#$UI.update_left_action($Spirit.gameState.left_action);
	#$UI.update_right_action($Spirit.gameState.right_action);
	if (Input.is_action_just_pressed("pause")):
		pause_game()
	if (Input.is_action_just_released("toggle_action")):
		toggle_moon_spirit_action();
	if (Input.is_action_just_pressed("action_assign_menu")):
		print("showing menu");
		$RadialActionSelect.show();
		get_tree().paused = true;
		
func _physics_process(delta):
	if ($Player.is_on_solid_ground()):
		$Spirit.regen_stamina(1);
func pause_game():
	$PauseMenu.show();
	$UI.hide();
	get_tree().paused = true;

func _on_pause_menu_restart():
	begin();


func _on_ui_pause():
	pause_game();

func _on_pause_menu_resume():
	$UI.show();


func _on_ui_moon_spirit_action_change(action):
	#print($Spirit.gameState.left_action);
	#update_moon_spirit_action(action);
	pass;

func toggle_moon_spirit_action():
	#if ($Spirit.gameState.left_action == "platform"):
	#	update_moon_spirit_action("default_action");
	#elif ($Spirit.gameState.left_action == "default"):
	#	update_moon_spirit_action("platform_action")
	pass;


func update_moon_spirit_left_action(action):
	$Spirit.gameState.left_action = action;
	$UI.update_left_action(action);
	
func update_moon_spirit_right_action(action):
	$Spirit.gameState.right_action = action;
	$UI.update_right_action(action);

func _on_player_death():
	#pause_game();
	begin();


func _on_radial_action_select_left_action_updated(action):
	update_moon_spirit_left_action(action);

func _on_radial_action_select_right_action_updated(action):
	update_moon_spirit_right_action(action);
