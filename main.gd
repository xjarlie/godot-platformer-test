extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	begin();


func begin():
	$Player.position = Vector2(296, 456);
	$Spirit.begin();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("pause")):
		pause_game()
		
func _physics_process(delta):
	
	if ($Player.is_on_floor()):
		$Spirit.regen_stamina(2);

func pause_game():
	$PauseMenu.show();
	get_tree().paused = true;

func _on_pause_menu_restart():
	begin();


func _on_ui_pause():
	pause_game();
