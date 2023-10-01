extends Control

@export var left_action_group: ButtonGroup;
@export var right_action_group: ButtonGroup;

signal left_action_updated(action);
signal right_action_updated(action);

var action_released = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	left_action_group.pressed.connect(update_left_action);
	right_action_group.pressed.connect(update_right_action);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("action_assign_menu") && action_released):
		action_released = false;
		close();
	if (Input.is_action_just_released("action_assign_menu")):
		
		action_released = true;

func update_left_action(button):
	var action = button.get_groups()[0];
	left_action_updated.emit(action);
	close();
	
func update_right_action(button):
	var action = button.get_groups()[0];
	right_action_updated.emit(action);
	close();

func close():
	print("closing menu");
	hide();
	get_tree().paused = false;

func _on_visibility_changed():
	position = get_global_mouse_position();
