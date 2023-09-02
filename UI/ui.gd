extends CanvasLayer

signal pause;

signal moon_spirit_action_change(action);

@export var action_button_group: ButtonGroup;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handle_action_change();

func handle_action_change():
	var button = action_button_group.get_pressed_button().get_groups()[0];
	moon_spirit_action_change.emit(button)

func _on_pause_button_pressed():
	pause.emit();

func update_stamina(value: int):
	$StaminaBar.value = value;
