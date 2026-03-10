@tool
extends Node2D
@onready var background_color_rect: ColorRect = $background_layer/background_color
@export var background_color:Color
@export_tool_button("Update Background Color") var button = update_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.cam_bounds = Vector4(-1000000,-1000000,1000000,350)
	update_color()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_color():
	background_color_rect.color = background_color
