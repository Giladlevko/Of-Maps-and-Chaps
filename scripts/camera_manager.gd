extends Camera2D
var shake_strength: float = 0.0
var shake_fade:float = 10
var shake_start:float = 10
var shake_end:float = 0
var shaking:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shaking = true
		shake_strength = lerp(shake_strength,shake_end,shake_fade*delta)
		offset = Vector2(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength)/4 - 30)
	else:
		offset = Vector2(0,-30)
		shaking = false

func shake_cam(start:float = 10):
	if !shaking:
		shake_strength = start
		
	else:
		shake_strength = 0
		shake_end = 0
