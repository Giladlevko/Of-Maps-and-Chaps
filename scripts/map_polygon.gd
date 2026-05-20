@tool
extends Polygon2D
@export var map_id:int = 0
@export var tile_map_layer:TileMapLayer
var rect = Rect2()
var start: Vector2i
var end: Vector2i
var sorted_corners: PackedVector2Array = []
var global_poly:PackedVector2Array = []
const GRID_STEP = 1
var MAP_SCALE:float
@onready var base_copy: Polygon2D = $base_copy

@export var sub_regions: Node2D

@export_tool_button("Add Sub Region!") var add_region:Callable = add_sub_region
@export_tool_button("Remove Sub Region") var remove_region:Callable = remove_sub_region
@export var sub_region_to_modify:int = -1

@export var sub_region_id:int:
	get():
		if sub_regions.get_child_count() > 0:
			if sub_region_to_modify <0: return -1
			if sub_region_to_modify>=sub_regions.get_child_count():return -1
			var sub_region:MAP_SUB_REGION = sub_regions.get_child(sub_region_to_modify)
			return sub_region.sub_id
		return map_id
	set(value):
		if sub_regions.get_child_count() > 0:
			if sub_region_to_modify <0: return
			if sub_region_to_modify>=sub_regions.get_child_count(): return
			#remove_sub_region()
			#call_deferred("add_sub_region",value)
			var sub_region:MAP_SUB_REGION = sub_regions.get_child(sub_region_to_modify)
			sub_region.set("sub_id",value)


@export_tool_button("Set Sub Region Poly") var edit_sub_poly:Callable = edit_sub_poly_region
@export_tool_button("Get Sub Region poly") var get_sub_poly:Callable = get_sub_region_poly
@export var base_poly:PackedVector2Array
@export_tool_button("Set Base Polygon") var set_base_poly:Callable = set_base_polygon
@export_tool_button("Get Base Polygon") var get_base_poly:Callable = get_base_polygon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		for child in sub_regions.get_children():
			print(child.name)
		# rect needed for easier check of tiles in the required region
		if tile_map_layer:
			SignalBus.get_map_poly_points.connect(send_points)
			for point in polygon:
				rect = rect.expand(to_global(point))
				global_poly.append(to_global(point))
			#print(rect,name)
			start = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position))
			end = tile_map_layer.to_global(tile_map_layer.local_to_map(rect.position + rect.size))
			#print("start: ",start,name)
			#print("end: ",end,name)
			start.x = snap_to_step(start.x,GRID_STEP)
			end.x = snap_to_step(end.x,GRID_STEP)
			start.y = snap_to_step(start.y,GRID_STEP)
			end.y  = snap_to_step(end.y,GRID_STEP)
			get_corners()
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tile_map_layer
	pass

func get_corners()->Array[Global.map_point]:
	var point_array:Array[Global.map_point]
# checks int points in rect and sees if there is a tile with those coordinates
	for tile in Global.corner_tiles:
		#print("tile: ",tile)
		var global_tile_pos:Vector2 = tile_map_layer.to_global(tile_map_layer.map_to_local(tile))
		if rect.has_point(global_tile_pos):
			if Geometry2D.is_point_in_polygon(global_tile_pos,global_poly):
				var point:Global.map_point = Global.map_point.new(map_id,global_tile_pos)
				point_array.append(point)
	#print("unsorted: ",point_array)
	return sort_points(point_array)
	#print("sorted_corners: ",sorted_corners)

func snap_to_step(value:float,step:int) -> int:
	var snapped_value:int = round(value/step)*step
	return snapped_value

func sort_points(points:Array[Global.map_point]) -> Array[Global.map_point]:
	var sorted_points:Array[Global.map_point]
	var last_object:Vector2 = Vector2.ZERO
	var points_copy:Array[Global.map_point] = points
	var prefers_x:bool = true
	var array_size:int = points.size()
	var failed_attempts:int = 0
	while points_copy.size()>0:
		for i in range(array_size):
			var point = points[i]
			
			if sorted_points.is_empty():
				sorted_points.append(point)
				points_copy.remove_at(i)
				#print(i,": ",sorted_points)
				#must use break so i would update and reset to 0 after removing point from original array 
				break
			elif prefers_x:
				last_object = get_last_point(sorted_points)
				#get matching points
				var matching_x_points:Array[Global.map_point] = get_matching_points(points,sorted_points,last_object,prefers_x)
				if matching_x_points.size() > 1:
					#if more than one matching point find the closest one
					var closest_point:Global.map_point = handle_multiple_matching_points(matching_x_points,last_object,prefers_x)
					#find and get remove the closest point 
					failed_attempts = move_point(sorted_points,points_copy,closest_point)
					prefers_x = false
					break
					
				elif matching_x_points.size() > 0:
					var matching_point:Global.map_point = matching_x_points[0]
					#find and remove the point 
					failed_attempts = move_point(sorted_points,points_copy,matching_point)
					prefers_x = false
					break
				else:
					prefers_x = false
					break
					pass
					
				
			else:
				last_object = get_last_point(sorted_points)
				var matching_y_points:Array[Global.map_point] = get_matching_points(points,sorted_points,last_object,prefers_x)
				if matching_y_points.size() > 1:
					#find and remove the closest point 
					var closest_point:Global.map_point = handle_multiple_matching_points(matching_y_points,last_object,prefers_x)
					failed_attempts = move_point(sorted_points,points_copy,closest_point)
					prefers_x = true
					break
				elif matching_y_points.size()>0:
					var matching_point:Global.map_point = matching_y_points[0]
					failed_attempts = move_point(sorted_points,points_copy,matching_point)
					prefers_x = true
					break
				else:
					# no y matching points
					failed_attempts+=1
					if failed_attempts>=points.size()*2:
						push_error("ERROR: MAP POINT SORTING FAILED!")
						return (sorted_points)
					prefers_x = true
					break
	#print("sorted: ",sorted_points)
	return (sorted_points)


func move_point(target_arr:Array[Global.map_point],curr_arr:Array[Global.map_point],point:Global.map_point)-> int:
	print("curr_arr.find(point): ",curr_arr.find(point))
	target_arr.append(point)
	curr_arr.remove_at(curr_arr.find(point))
	var failed_amount:int = 0
	return failed_amount
	

#TODO make a function that checks if thre is an inner block between two potentiol neighbors
#DONE 
func get_matching_points(
	points_array:Array[Global.map_point],sorted_points:Array[Global.map_point],last_object:Vector2,prefers_x:bool
	)-> Array[Global.map_point]:
	
	var matching_points:Array[Global.map_point]
	for j in range(points_array.size()):
		if !sorted_points.has(points_array[j]):
			if prefers_x:
				if (points_array[j].x == last_object.x):
					if !has_inner_block_between(last_object,points_array[j].coord):
						#get all matching points
						matching_points.append(points_array[j])
			else:
				if (points_array[j].y == last_object.y):
					if !has_inner_block_between(last_object,points_array[j].coord):
						#get all matching points
						matching_points.append(points_array[j])
	#print("prefers_x: ",prefers_x,": ",matching_points)
	#print("points_array: ",points_array)
	if matching_points.is_empty():
		push_warning("ERORR: NO MATCHING POINTS FOUND!!! Last point: ",last_object," prefers_x: ",prefers_x)
		push_warning(" sorted points: ",sorted_points)
		push_warning(" all points: ",points_array)
	return matching_points


func handle_multiple_matching_points(matching_points:Array,last_object:Vector2,prefers_x:bool) -> Global.map_point:
	var distance_of_points:Dictionary
	for x_point_index in matching_points.size():
		var i_point:Global.map_point = matching_points[x_point_index]
		#makes the distance the key and the point the value for easy sorting and access
		#print("ORIGINAL POINT = ",last_object)
		#print("X POINT = ",x_point)
		if prefers_x:
			distance_of_points[abs( last_object.y - i_point.y )] = i_point
		else:
			distance_of_points[abs(last_object.x - i_point.x )] = i_point
	var keys:Array = distance_of_points.keys()
	keys.sort()
	#print("CHOSEN OBJECT BASED ON DISTANCE: ",distance_of_points[distance_of_points.keys()[0]])
	return distance_of_points[keys[0]]

func get_last_point(arr:Array[Global.map_point])->Vector2:
	return arr[arr.size()-1].coord


func has_inner_block_between(point:Vector2,potential_match:Vector2)->bool:
	#print("#############POINT: ",point,"  POTENTIAL: ",potential_match)
	var dir: Vector2i = Vector2i((potential_match-point).sign())
	#print("################## DIR: ",dir)
	var local_map_point:Vector2 = tile_map_layer.to_local(point)
	var coord:Vector2i = tile_map_layer.local_to_map(local_map_point)
	var neighbor_type:TileSet.CellNeighbor
	match dir:
		Vector2i.RIGHT: neighbor_type = TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE
		Vector2i.UP: neighbor_type = TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE
		Vector2i.LEFT: neighbor_type = TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE
		Vector2i.DOWN: neighbor_type = TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE
		_:
			push_error("########ERROR ANGLE OF TWO POTENTIAL NEIGHBORS DOESN'T MATCH!!!!########","   DIR IS: ",dir)
			return true
	var neighbor_tile:Vector2i = tile_map_layer.get_neighbor_cell(coord,neighbor_type)
	var data:TileData = tile_map_layer.get_cell_tile_data(neighbor_tile)
	
	if !data:return false
	#print("################### NEIGHBOR: ",neighbor_tile," DATA: ",data.get_custom_data("inner_block"))
	return data.get_custom_data("inner_block") == true
	
	pass


func send_points(recived_id:int):
	if map_id == recived_id:
		var sorted_map_points:Array[Global.map_point] = get_corners()
		#var points_array:PackedVector2Array = polygon
		#points_array.append(polygon[0])
		#var array_size = points_array.size()
		#var lowest_x = get_lowest_x(points_array)
		
		
		if sorted_map_points.is_empty():
			return
		
		if sub_regions.get_child_count()>0:
			for child:MAP_SUB_REGION in sub_regions.get_children():
				sorted_map_points = child.update_main_reg_points(sorted_map_points)
		
		var closing_point:Global.map_point = Global.map_point.new(
			sorted_map_points[0].point_id,sorted_map_points[0].coord
			)
		sorted_map_points.append(closing_point)
			#points_array[point] += Vector2(40,500)
			
		#for point in sorted_map_points:
			#point.print_point()
		SignalBus.update_map.emit(sorted_map_points,map_id)
		#print(points_array)

var child_indx:int = 0
#var sub_reg:MAP_SUB_REGION = MAP_SUB_REGION.new()
func add_sub_region(sub_id:int = 0):
	const SUB_POLY:PackedScene = preload("res://scenes/map_sub_region.tscn")
	var sub_reg = SUB_POLY.instantiate()
	
	sub_regions.add_child(sub_reg)
	sub_reg.owner = get_tree().edited_scene_root
	sub_reg.sub_id = sub_id
	sub_reg.reg_color = Color(randf_range(50,255)/255,randf_range(50,255)/255,randf_range(50,255)/255,80.0/255)
	sub_reg.name = "sub_"+str(child_indx)
	
	sub_region_to_modify = sub_regions.get_child_count() - 1
	#set_editable_instance(get_child(child_indx),true)
	
	child_indx+=1
	print("added sub region to owner: ",sub_reg.owner)
	pass

func remove_sub_region():
	if (sub_region_to_modify <0) or (sub_region_to_modify >= sub_regions.get_child_count()): return
	sub_regions.get_child(sub_region_to_modify).queue_free()
	child_indx-=1


func set_base_polygon():
	base_poly = polygon
	base_copy.polygon = base_poly
	

func get_base_polygon():
	if base_poly.is_empty():return
	polygon = base_poly 

func edit_sub_poly_region():
	if (sub_region_to_modify <0) or (sub_region_to_modify>=sub_regions.get_child_count()):
		print("Cant set sub reg!",sub_region_to_modify,)
		return
	var sub_poly:MAP_SUB_REGION = sub_regions.get_child(sub_region_to_modify)
	sub_poly.sub_poly_points = polygon
	#notify_property_list_changed()

func get_sub_region_poly():
	if (sub_region_to_modify <0) or (sub_region_to_modify>=sub_regions.get_child_count()):return
	var sub_poly:MAP_SUB_REGION = sub_regions.get_child(sub_region_to_modify)
	polygon = sub_poly.sub_poly_points
	

func get_lowest_x(points: PackedVector2Array) -> float:
	if points.is_empty():
		return 0
	var lowest_x = points[0].x / 6
	for point in points:
		if point.x < lowest_x:
			lowest_x = point.x / 6
	return lowest_x
