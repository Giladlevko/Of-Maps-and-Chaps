extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var gravity:int = 900
var in_area:bool
var player:CharacterBody2D
var dialog_id:int = 1
var dialog_playing:bool
@export var end_position:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(on_dialog_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity*delta
	else: velocity.y = 0
	if in_area and Input.is_action_just_pressed("interact") and !dialog_playing:
		Dialogic.start("Dialog_"+str(dialog_id))
		dialog_id += 1
		dialog_playing = true
		player.popup.hide()
	move_and_slide()
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "teleport":
		position = end_position
		dialog_playing = false
		anim.play("idle")
		pass

func on_dialog_signal(arg: String):
	if arg == "finished_dialog_1":
		anim.play("teleport")
		player.can_move = true
	if arg == "give_ink":
		Global.ink_amount = clamp(Global.ink_amount+10,0,Global.max_ink)
		SignalBus.update_ink.emit()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
