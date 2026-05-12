extends Control
@export var flag_id:int
@export var flag_world_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	SignalBus.map_flag_pressed.emit(flag_world_pos)
