extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(on_dialog_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "teleport":
		pass

func on_dialog_signal(arg: String):
	if arg == "finished_dialog_1":
		anim.play("teleport")
	if arg == "give_ink":
		Global.ink_amount = clamp(Global.ink_amount+10,0,Global.max_ink)
