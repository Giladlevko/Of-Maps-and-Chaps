extends Polygon2D
@export var map_id:int = 0
@export var tile_map_layer:TileMapLayer
var rect = Rect2(polygon[0],Vector2.ZERO)
var start: Vector2
var end: Vector2
var corners_array:PackedVector2Array = []
var global_poly:PackedVector2Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.get_map_poly_points.connect(send_points)
	# rect needed for easier check of tiles in the required region
	if tile_map_layer:
		for point in polygon:
			rect = rect.expand(to_global(point))
			global_poly.append(to_global(point))
		print(rect)
		start = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position))
		end = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position + rect.size))
		get_corners()

# TODO 
#use get_used_cells_by_id to get corners, then get corners position then sort the positions to ensure
# the polyline works as intended

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tile_map_layer
	pass

func get_corners():
	# checks int points in rect and sees if there is a tile with those coordinates
	for x in range(start.x,end.x+1):
		for y in range(start.y,end.y+1):
			var tile = Vector2i(x,y)
			var data = tile_map_layer.get_cell_tile_data(tile)
			if data:
				var global_tile_pos:Vector2 = tile_map_layer.to_global(tile_map_layer.map_to_local(tile))
				if Geometry2D.is_point_in_polygon(global_tile_pos,global_poly):
					if data.get_custom_data("corners") == true:
						corners_array.append(global_tile_pos)
	print("unsorted: ",corners_array)
	sort_points(corners_array)
	

func sort_points(points:PackedVector2Array):
	var sorted_points:PackedVector2Array = PackedVector2Array()
	var last_object = 0
	while points.size()>0:
		for i in range(points.size()):
			var point = points[i]
			last_object = sorted_points.size() - 1
			if sorted_points.is_empty():
				sorted_points.append(point)
				points.remove_at(i)
			elif (point.x == sorted_points[last_object].x) or (point.y == sorted_points[last_object].y):
				if !sorted_points.has(point):
					sorted_points.append(point)
					points.remove_at(i)
					break
					
			else:
				pass
			
			
	print("sorted: ",sorted_points)
	pass

func send_points(recived_id:int):
	if map_id == recived_id:
		var points_array:PackedVector2Array = polygon
		points_array.append(polygon[0])
		var array_size = points_array.size()
		var lowest_x = get_lowest_x(points_array)
		for point in array_size:
			points_array[point] = points_array[point]/Vector2(6,6)
			
			points_array[point] += Vector2(40,500)
			print(points_array[point])
		SignalBus.update_map.emit(points_array,map_id)
		print(points_array)


func get_lowest_x(points: PackedVector2Array) -> float:
	if points.is_empty():
		return 0
	var lowest_x = points[0].x / 6
	for point in points:
		if point.x < lowest_x:
			lowest_x = point.x / 6
	return lowest_x
