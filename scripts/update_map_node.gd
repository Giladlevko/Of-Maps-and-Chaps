@tool
extends Area2D
var in_area:bool
var player:CharacterBody2D
@onready var colli: CollisionShape2D = $CollisionShape2D
@export var map_update_id:int
@export var ink_cost:int = 0
@export_tool_button("update") var update = update_label
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		label.visible = false
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body
		handle_map_update()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false

func update_label():
	label.text = "ID: "+str(map_update_id) +"  Cost: "+ str(ink_cost)
	

func handle_map_update():
	if !Global.updated_areas.has(map_update_id):
		if Global.ink_amount >= ink_cost:
			Global.updated_areas.append(map_update_id)
			SignalBus.message_popup.emit("Map Updated!")
			SignalBus.get_map_poly_points.emit(map_update_id)
			Global.ink_amount = clamp(Global.ink_amount-ink_cost,0,Global.max_ink)
			await get_tree().create_timer(2.8).timeout
			SignalBus.update_ink.emit()
		else:
			SignalBus.message_popup.emit("More Ink Needed!")
			if !Global.not_updated_map_visited_areas.has(self):
				Global.not_updated_map_visited_areas.append(self)
