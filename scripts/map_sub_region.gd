@tool
class_name MAP_SUB_REGION
extends Polygon2D
@export var sub_id:int:
	get():
		return sub_id
	set(value):
		sub_id = value
		print(name,"'s new id value is: ", value)
		 
@export var sub_poly_points:PackedVector2Array:
	get():
		return sub_poly_points
	set(value):
		sub_poly_points = value
		polygon = sub_poly_points
		print(name,"'s new poins are: ", value)

@export var reg_color:Color:
	set(value):
		reg_color = value
		color = value
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_poly_points = polygon
	color = reg_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_main_reg_points(points:Array[Global.map_point])->Array[Global.map_point]:
	for point in points:
		if Geometry2D.is_point_in_polygon(point.coord,polygon):
			point.point_id = sub_id
	return points
