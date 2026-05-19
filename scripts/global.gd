extends Node

var ink_amount:int = 0
var max_ink:int = 10
var correct_skulls: Array = []
var skulls_can_give: bool = true
var wall_jump_unlocked:bool = true
var dash_unlocked: bool = true
var super_dash_unlocked:bool
var double_jump_unlocked:bool
var reached_check_points:Array = []
var updated_areas:Array = []
var areas_amount: int = 12
var not_updated_map_visited_areas:Array
var current_level: String = "level_1"
var player_pos:Vector2
var current_dialog_id:int = 3
var corner_tiles:PackedVector2Array = []
var MAP_COORD_MIN:Vector2
var MAP_COORD_MAX:Vector2
var MIN_POS:Vector2

## A point with Coordinates and ID, used for map drawing and handling
class map_point:
	##Creates a Point With Coordinates and ID
	func _init(id:int=0,v:Vector2=Vector2.ZERO):
		point_id = id
		coord = v
	var point_id:int
	var coord:Vector2
	
	var x: float:
		get():
			return coord.x
	
	var y:float = 0.0:
		get():
			return coord.y
	func print_point():
		print("coord: ",coord," id: ",point_id)


##(left:x,top:y,right:z,bottom:w)
var cam_bounds:Vector4 = Vector4(-1000000,-1000000,1000000,350):
	set(value):
		SignalBus.update_cam_bounds.emit(value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.calc_map_scale.connect(get_map_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_map_scale(points_arr:PackedVector2Array = corner_tiles):
	var max_pos:Vector2 = points_arr[0]
	var min_pos:Vector2 = points_arr[0]
	for p in points_arr:
		max_pos.x = maxf(max_pos.x,p.x)
		max_pos.y = minf(max_pos.y,p.y)
		min_pos.x = minf(min_pos.x,p.x)
		min_pos.y = maxf(min_pos.y,p.y)
	MAP_COORD_MIN = min_pos*16
	MAP_COORD_MAX = max_pos*16
	#for i in points_arr.size():
		#points_arr[i]-=min_pos
	
	var map_size:Vector2 = abs(max_pos - min_pos)*16
	print("#################### MAP_SIZE: ",map_size,MAP_COORD_MAX,MAP_COORD_MIN,"#####################")
	var MAP_UI_SIZE:Vector2 = Vector2(1200,600)
	var map_scale:float = minf(MAP_UI_SIZE.x/map_size.x,MAP_UI_SIZE.y/map_size.y)
	
