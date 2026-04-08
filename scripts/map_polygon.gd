extends Polygon2D
@export var map_id:int = 0
@export var tile_map_layer:TileMapLayer
var rect = Rect2(polygon[0],Vector2.ZERO)
var start: Vector2i
var end: Vector2i
var corners_array:PackedVector2Array = []
var sorted_corners: PackedVector2Array = []
var global_poly:PackedVector2Array = []
const GRID_STEP = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	# rect needed for easier check of tiles in the required region
	if tile_map_layer:
		SignalBus.get_map_poly_points.connect(send_points)
		for point in polygon:
			rect = rect.expand(to_global(point))
			global_poly.append(to_global(point))
		print(rect,name)
		start = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position))
		end = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position + rect.size))
		print("start: ",start,name)
		print("end: ",end,name)
		start.x = snap_to_step(start.x,GRID_STEP)
		end.x = snap_to_step(end.x,GRID_STEP)
		start.y = snap_to_step(start.y,GRID_STEP)
		end.y  = snap_to_step(end.y,GRID_STEP)
		get_corners()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tile_map_layer
	pass

func get_corners():
# checks int points in rect and sees if there is a tile with those coordinates
	
	for tile in Global.corner_tiles:
		print("tile: ",tile)
		var global_tile_pos:Vector2 = tile_map_layer.to_global(tile_map_layer.map_to_local(tile))
		if rect.has_point(global_tile_pos):
			if Geometry2D.is_point_in_polygon(global_tile_pos,global_poly):
				corners_array.append(global_tile_pos)
	print("unsorted: ",corners_array)
	sort_points(corners_array)
	#var unpacked_corners:Array = corners_array
	#unpacked_corners.sort_custom(sort_corners)
	#unpacked_corners.sort_custom(sort_corners)
	#for i in unpacked_corners.size():
		#sorted_corners.append(unpacked_corners[i])
	print("sorted_corners: ",sorted_corners)

func snap_to_step(value:float,step:int) -> int:
	var snapped_value:int = round(value/step)*step
	return snapped_value

func sort_points(points:PackedVector2Array) -> PackedVector2Array:
	var sorted_points:PackedVector2Array = PackedVector2Array()
	var last_object = 0
	var points_copy = points
	var prefers_x:bool = true
	var failed_attempts:int = 0
	while points_copy.size()>0:
		for i in range(points.size()):
			var point = points[i]
			
			if sorted_points.is_empty():
				sorted_points.append(point)
				points_copy.remove_at(i)
				#print(i,": ",sorted_points)
				#must use break so i would update and reset to 0 after removing point from original array 
				break
			elif prefers_x:
				last_object = sorted_points.size() - 1
				#get matching points
				var matching_x_points:Array = get_matching_points(points,sorted_points,point,last_object,prefers_x)
				
				if matching_x_points.size() > 1:
					#if more than one matching point find the closest one
					var closest_point = handle_multiple_matching_points(matching_x_points,sorted_points,last_object,prefers_x)
					sorted_points.append(closest_point)
					
					#find and get remove the closest point 
					#print("points_copy_BEFORE: ",points_copy)
					points_copy.remove_at(points_copy.find(closest_point))
					#print("points_copy_AFTER: ",points_copy)
					prefers_x = false
					#print(i,": ",sorted_points)
					break
					
				elif matching_x_points.size() > 0:
					var matching_point:Vector2 = matching_x_points[0]
					sorted_points.append(matching_x_points[0])
					#print("points_copy_BEFORE: ",points_copy)
					points_copy.remove_at(points_copy.find(matching_point))
					#print("points_copy_AFTER: ",points_copy)
					#print(i,": ",sorted_points)
					prefers_x = false
					
					break
				else:
					#no x_matching points
					prefers_x = false
			else:
				last_object = sorted_points.size() - 1
				var matching_y_points = get_matching_points(points,sorted_points,point,last_object,prefers_x)
				
				if matching_y_points.size() > 1:
					var closest_point = handle_multiple_matching_points(matching_y_points,sorted_points,last_object,prefers_x)
					sorted_points.append(closest_point)
					#find and remove the closest point 
					#print("points_copy_BEFORE: ",points_copy)
					points_copy.remove_at(points_copy.find(closest_point))
					#print("points_copy_AFTER: ",points_copy)
					prefers_x = true
					print(i,": ",sorted_points)
					break
				elif matching_y_points.size()>0:
					var matching_point:Vector2 = matching_y_points[0]
					sorted_points.append(matching_y_points[0])
					#print("points_copy_BEFORE: ",points_copy)
					points_copy.remove_at(points_copy.find(matching_point))
					#print("points_copy_AFTER: ",points_copy)
					prefers_x = true
					print(i,": ",sorted_points)
					#must use break so i would update and reset to 0 after removing point from original array 
					break
				else:
					# no y matching points
					prefers_x = true
					failed_attempts+=1
					if failed_attempts>=points.size()*2:
						print("FAILED FAILED FAILED AND FAILED!!!################################################### ")
						return sorted_points
					break
	for point in range(sorted_points.size()):
		sorted_points[point] = to_global(sorted_points[point])
	sorted_corners = sorted_points
	print("sorted: ",sorted_points)
	return sorted_points


func get_matching_points(
	points_array:Array,sorted_points:Array,original_point:Vector2,last_object:int,prefers_x:bool
	)-> Array:
	
	var matching_points:Array
	for j in range(points_array.size()):
		if prefers_x:
			if (points_array[j].x == sorted_points[last_object].x) and !sorted_points.has(points_array[j]):
				#get all matching points
				matching_points.append(points_array[j])
		else:
			if (points_array[j].y == sorted_points[last_object].y) and !sorted_points.has(points_array[j]):
				#get all matching points
				matching_points.append(points_array[j])
	#print("prefers_x: ",prefers_x,": ",matching_points)
	#print("points_array: ",points_array)
	return matching_points


func handle_multiple_matching_points(matching_points:Array,sorted_points:Array,last_object:int,prefers_x:bool) -> Vector2:
	var distance_of_points:Dictionary
	for x_point_index in matching_points.size():
		var i_point = matching_points[x_point_index]
		#makes the distance the key and the point the value for easy sorting and access
		#print("ORIGINAL POINT = ",sorted_points[last_object])
		#print("X POINT = ",x_point)
		if prefers_x:
			distance_of_points[abs( sorted_points[last_object].y - i_point.y )] = i_point
		else:
			distance_of_points[abs( sorted_points[last_object].x - i_point.x )] = i_point
	var keys:Array = distance_of_points.keys()
	keys.sort()
	print("CHOSEN OBJECT BASED ON DISTANCE: ",distance_of_points[distance_of_points.keys()[0]])
	return distance_of_points[keys[0]]

func sort_corners(a:Vector2,b:Vector2) -> bool:
	if (a.x == b.x or a.y == b.y) and (a!=b):
		return true
	return false


func send_points(recived_id:int):
	
	if map_id == recived_id:
		get_corners()
		#var points_array:PackedVector2Array = polygon
		#points_array.append(polygon[0])
		#var array_size = points_array.size()
		#var lowest_x = get_lowest_x(points_array)
		if sorted_corners.is_empty():
			return
		var points_array = sorted_corners
		points_array.append(points_array[0])
		for point in points_array.size():
			points_array[point] = points_array[point]/Vector2(6,6)
			points_array[point] += Vector2(40,500)
			
		
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
