extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animation = "spirit";

func update_animation(ani: String):
	if (animation != ani):
		play(ani);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
