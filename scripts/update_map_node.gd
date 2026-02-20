extends Area2D
var in_area:bool
var player:CharacterBody2D
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
@export var map_update_id:int
@export var ink_cost:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body
		if !Global.updated_areas.has(map_update_id):
			if Global.ink_amount >= ink_cost:
				SignalBus.message_popup.emit("Map Updated!")
				SignalBus.update_map.emit(map_update_id)
				await get_tree().create_timer(3).timeout
				Global.ink_amount = clamp(Global.ink_amount-ink_cost,0,Global.max_ink)
				SignalBus.update_ink.emit()
			else:
				SignalBus.message_popup.emit("More Ink Needed!")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
