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
	
	for id in map_ids:
		for poly:PackedVector2Array in map_areas[id]:
			draw_polyline_colors(poly,[Color(1,1,1,1)])
			#print("poly: ", poly,type_string(typeof(poly)))
		
		
		

func handle_map_update(map_poly:PackedVector2Array,poly_id:int):
	if !map_poly.is_empty():
		scale_points(map_poly)
		if !map_areas.has(poly_id):
			map_areas[poly_id] = [map_poly]
			print("map_poly ",map_poly)
		else:
			map_areas[poly_id].append(PackedVector2Array(map_poly))
		map_ids.append(poly_id)
		queue_redraw()

func scale_points(sorted_corners:PackedVector2Array):
	var MAP_UI_HEIGHT =648
	var MAP_UI_LENGTH = 1152
	var points_array:PackedVector2Array = sorted_corners
	
	for point in points_array.size():
		print("Before: ",points_array[point])
		points_array[point].x = (remap(points_array[point].x,Global.MAP_COORD_MIN.x,Global.MAP_COORD_MAX.x,0,MAP_UI_LENGTH))
		points_array[point].y = (remap(points_array[point].y,Global.MAP_COORD_MIN.y,Global.MAP_COORD_MAX.y,MAP_UI_HEIGHT,0))
		print("After: ",points_array[point])
