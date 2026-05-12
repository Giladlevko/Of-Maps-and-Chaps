extends Control
var map_areas:Dictionary = {}
var map_ids:Array
const CHECK_POINT_FLAG:PackedScene = preload("res://scenes/map_flag_button.tscn")

@export var player_icon:Control
@export var check_points:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_map.connect(handle_map_update)
	SignalBus.add_check_point_to_map.connect(on_check_point_reached)
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_icon.position = scale_point(Global.player_pos) - player_icon.size*0.5


func center_pivot(node:Control):
	node.pivot_offset = node.size*0.5

func _draw() -> void:
	
	for id in map_ids:
		for poly:PackedVector2Array in map_areas[id]:
			draw_polyline_colors(poly,[Color(1,1,1,1)])
			#print("poly: ", poly,type_string(typeof(poly)))
		
		

func on_check_point_reached(check_point_pos:Vector2):
	var flag = CHECK_POINT_FLAG.instantiate()
	flag.flag_world_pos = check_point_pos
	var flag_map_pos:Vector2 = scale_point(check_point_pos) - flag.size*0.5
	flag.position = flag_map_pos
	check_points.add_child(flag)
	
	pass

func handle_map_update(map_poly:PackedVector2Array,poly_id:int):
	if !map_poly.is_empty():
		scale_map_points(map_poly)
		if !map_areas.has(poly_id):
			map_areas[poly_id] = [map_poly]
			print("map_poly ",map_poly)
		else:
			map_areas[poly_id].append(PackedVector2Array(map_poly))
		map_ids.append(poly_id)
		queue_redraw()

func scale_point(point:Vector2)->Vector2:
	var map_x_size:float = abs(Global.MAP_COORD_MAX.x - Global.MAP_COORD_MIN.x)
	var map_y_size:float = abs(Global.MAP_COORD_MAX.y - Global.MAP_COORD_MIN.y)
	const margin_val = 30
	const MAP_UI_LENGTH = 1152 - margin_val
	const Y_START_VAL = 648 - margin_val
	var MAP_UI_HEIGHT = MAP_UI_LENGTH*(map_y_size/map_x_size)
	
	point.x = (remap(point.x,Global.MAP_COORD_MIN.x,Global.MAP_COORD_MAX.x,margin_val,MAP_UI_LENGTH))
	point.y = (remap(point.y,Global.MAP_COORD_MIN.y,Global.MAP_COORD_MAX.y,Y_START_VAL,MAP_UI_HEIGHT))
	
	return point


func scale_map_points(sorted_corners:PackedVector2Array):
	var points_array:PackedVector2Array = sorted_corners
	for point in points_array.size(): 
		#print("Before: ",points_array[point])
		points_array[point] = scale_point(points_array[point])
		#print("After: ",points_array[point])
