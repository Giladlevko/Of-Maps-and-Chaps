extends Sprite2D
var in_area:bool
var player:CharacterBody2D
var ability_key_finder: Dictionary = {}
@export_enum("Wall-Jump","Dash","Super-Dash","Double-Jump") var ability_type:String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_key_finder = {
		"Wall-Jump": Global.wall_jump_unlocked,
		"Dash": Global.dash_unlocked,
		"Super-Dash": Global.super_dash_unlocked,
		"Double-Jump": Global.double_jump_unlocked
	}
	animate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			print("pressed")
			player.popup.hide()
			ability_key_finder[ability_type] = true
			SignalBus.message_popup.emit(ability_type+" Unlocked!")
			queue_free()
		
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false

func animate():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops()
	tween.tween_property(self,"position",Vector2(position.x,position.y + 3),1)
	tween.tween_property(self,"position",Vector2(position.x,position.y - 3),1)
