extends Control
var map_areas:Dictionary = {}
var map_ids:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_map.connect(handle_map_update)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	for area in map_ids:
		draw_polyline_colors(map_areas[area],[Color(1,1,1,1)])
		print(map_areas[area])
		
		
		

func handle_map_update(map_poly:PackedVector2Array,poly_id:int):
	map_areas[poly_id] = map_poly
	map_ids.append(poly_id)
	queue_redraw()
