extends CanvasLayer

signal pause;

signal moon_spirit_action_change(action);


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pause_button_pressed():
	pause.emit();

func update_stamina(value: int):
	$StaminaBar.value = value;
	
func update_health(value: int):
	$HealthBar.value = value;

func update_left_action(action: String):
	$LeftAction.text = "Left: " + action;
	
func update_right_action(action: String):
	$RightAction.text = "Right: " + action;
