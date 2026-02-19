extends AnimatedSprite2D
var in_area:bool
var player:CharacterBody2D
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
@export_enum("ink_amount","max_ink") var prize_type: String = "ink_amount"

@export var ink_amount:int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			print("pressed")
			player.popup.hide()
			if prize_type == "ink_amount":
				Global.ink_amount =clamp(Global.ink_amount+ink_amount,0,Global.max_ink)
			if prize_type == "max_ink":
				Global.max_ink += ink_amount
			SignalBus.update_ink.emit(prize_type)
			play("open")
			colli.disabled = true
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
