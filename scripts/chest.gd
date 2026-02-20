extends AnimatedSprite2D
var in_area:bool
var player:CharacterBody2D
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
@export_enum("ink_amount","max_ink") var prize_type: String = "ink_amount"

@export var ink_amount:int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if prize_type == "ink_amount":
		animation = "red_plant"
		frame = 0
		pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			print("pressed")
			player.popup.hide()
			if prize_type == "ink_amount":
				if Global.ink_amount != Global.max_ink:
					Global.ink_amount =clamp(Global.ink_amount+ink_amount,0,Global.max_ink)
					play("red_plant")
					colli.disabled = true
					SignalBus.update_ink.emit(prize_type)
				else:
					SignalBus.message_popup.emit("Reached Max Ink!")
			if prize_type == "max_ink":
				Global.max_ink += ink_amount
				play("open_chest")
				colli.disabled = true
				SignalBus.update_ink.emit(prize_type)
				
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
