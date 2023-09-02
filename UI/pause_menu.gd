extends CanvasLayer

signal restart;
signal resume;

# Called when the node enters the scene tree for the first time.
func _ready():
	hide(); # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if (Input.is_action_just_pressed("pause")):
		#_on_button_pressed();
	pass;


func _on_resume_button_pressed():
	hide();
	get_tree().paused = false;
	resume.emit();


func _on_restart_button_pressed():
	hide();
	get_tree().paused = false;
	restart.emit();
