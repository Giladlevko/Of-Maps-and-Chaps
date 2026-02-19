extends Control
class_name UI
@onready var ink_label: Label = $ink_diplay_container/HBoxContainer/ink_label
@onready var ink_anim: AnimationPlayer = $ink_diplay_container/HBoxContainer/ink_anim
var prev_ink:int
@onready var message_label: Label = $message_container/VBoxContainer/message_label
@onready var death_rect: ColorRect = $death_screen/death_rect
@onready var death_label: Label = $death_screen/VBoxContainer/death_label
var player = preload("res://scenes/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_ink.connect(update_ink_count)
	SignalBus.message_popup.connect(on_message_recived)
	SignalBus.player_died.connect(on_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_ink_count(type:String = "ink_amount"):
	ink_label.text = "Ink:"+str(Global.ink_amount)+"/"+str(Global.max_ink)
	ink_anim.play("shine")
	if type == "ink_amount":
		if prev_ink > Global.ink_amount:
			on_message_recived("ink Used!")
		else:
			on_message_recived("Ink Added!")
			prev_ink = Global.ink_amount
	if type == "max_ink":
		on_message_recived("Larger Ink Pouch!")
	await get_tree().create_timer(2).timeout
	ink_anim.stop()

func on_message_recived(message:String):
	message_label.text = message
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(message_label,"modulate",Color(1,1,1,1),0.75)
	tween.tween_interval(1.25)
	tween.tween_property(message_label,"modulate",Color(1,1,1,0),0.75)

func on_died():
	print("1")
	var tween = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(death_rect,"modulate",Color(0,0,0,1),0.15)
	tween.tween_property(death_label,"modulate",Color(1,1,1,1),0.75)
	tween.tween_interval(1)
	SignalBus.death_finished.emit()
	tween.tween_property(death_label,"modulate",Color(1,1,1,0),0.75)
	tween.tween_property(death_rect,"modulate",Color(0,0,0,0),0.75)
