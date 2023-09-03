extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PopupPanel.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_win_area_body_entered(body):
	if (body.is_in_group("player")):
		print("YOU WIN");
		$PopupPanel.popup();
