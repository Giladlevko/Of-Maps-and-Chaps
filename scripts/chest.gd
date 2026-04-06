@tool
extends AnimatedSprite2D
var in_area:bool
var player:CharacterBody2D
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
@export_enum("ink_amount","max_ink") var prize_type: String = "ink_amount"
@export var new_chest_1: Texture2D
@export var new_chest_2: Texture2D
@export var new_ink_1: Texture2D
@export var new_ink_2: Texture2D
@export var ink_amount:int = 5

@export_tool_button("Update Anim") var update = handle_anim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_anim()


func handle_anim():
	if new_chest_1 and new_chest_2:
		new_anim("open_chest",new_chest_1,new_chest_2)
	if new_ink_1 and new_ink_2:
		new_anim("add_ink",new_ink_1,new_ink_2)
	
	if prize_type == "ink_amount":
		animation = "add_ink"
		frame = 0
		pause()

func new_anim(anim:String,frame_1:Texture2D,frame_2:Texture2D):
	sprite_frames.clear(anim)
	sprite_frames.add_frame(anim,frame_1)
	sprite_frames.add_frame(anim,frame_2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			print("pressed")
			player.popup.hide_()
			if prize_type == "ink_amount":
				if Global.ink_amount != Global.max_ink:
					if ceili(0.5*Global.max_ink)>ink_amount:
						Global.ink_amount =clamp(Global.ink_amount+ceili(0.5*Global.max_ink),0,Global.max_ink)
					else:
						Global.ink_amount =clamp((Global.ink_amount+ink_amount),0,Global.max_ink)
					play("add_ink")
					colli.disabled = true
					SignalBus.update_ink.emit(prize_type)
					if !Global.not_updated_map_visited_areas.is_empty():
						await get_tree().create_timer(2.8).timeout
						try_updating_map_again()
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


func try_updating_map_again():
	for object in Global.not_updated_map_visited_areas:
		if object.ink_cost < Global.ink_amount:
			object.handle_map_update()
			Global.not_updated_map_visited_areas.erase(object)
			await get_tree().create_timer(2.8).timeout
			
			
	pass
