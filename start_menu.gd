extends Node2D

var loading = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (loading != ""):
		var progress = [];
		ResourceLoader.load_threaded_get_status(loading, progress);
		$Control/LoadingControl/LoadingBar.value = progress[0] * 100;
		if (progress[0] == 1):
			get_tree().change_scene_to_file(loading);


func _on_story_pressed():
	$Control/ButtonControl.hide();
	$Control/LoadingControl.show();
	loading = "res://main.tscn";
	ResourceLoader.load_threaded_request(loading);
