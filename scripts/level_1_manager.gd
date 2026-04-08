@tool
extends Node2D
@onready var background_color_rect: ColorRect = $background_layer/background_color
@export var background_color:Color
@export var tile_map_layer:TileMapLayer
@export_tool_button("Update Background Color") var button = update_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.cam_bounds = Vector4(-1000000,-1000000,1000000,350)
	if background_color_rect:
		update_color()
	if tile_map_layer:
		get_corners() 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_color():
	background_color_rect.color = background_color

func get_corners():
	var all_corner_tiles = []
	for tile in tile_map_layer.get_used_cells():
		var data = tile_map_layer.get_cell_tile_data(tile)
		if data and data.get_custom_data("corners") == true:
			all_corner_tiles.append(tile)
	Global.corner_tiles = all_corner_tiles
	print("Global.corner_tiles: ",Global.corner_tiles)
