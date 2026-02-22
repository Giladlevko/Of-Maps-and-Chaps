extends Sprite2D
var in_area:bool
var player:CharacterBody2D
var ability_key_finder: Dictionary = {}
@export_enum("Wall-Jump","Dash","Super-Dash","Double-Jump") var ability_type:String
var controls:Dictionary = {}
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_key_finder = {
		"Wall-Jump": "wall_jump_unlocked",
		"Dash": "dash_unlocked",
		"Super-Dash": "super_dash_unlocked",
		"Double-Jump": "double_jump_unlocked"
	}
	controls = {
		"Wall-Jump": "Space + A or D near walls",
		"Dash": "A or D + Shift",
		"Super-Dash": "super_dash_unlocked",
		"Double-Jump": "double_jump_unlocked"
	}
	animate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			print("pressed")
			player.popup.hide_()
			var prop = ability_key_finder[ability_type]
			Global.set(prop, true)
			SignalBus.message_popup.emit(ability_type+" Unlocked!")
			colli.disabled = true
			visible = false
			await get_tree().create_timer(3).timeout
			SignalBus.message_popup.emit( "Press "+controls[ability_type])
			queue_free()
		
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false

func animate():
	var tween = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops().bind_node(self)
	tween.tween_property(self,"position",Vector2(position.x,position.y + 3),1)
	tween.tween_property(self,"position",Vector2(position.x,position.y - 3),1)
