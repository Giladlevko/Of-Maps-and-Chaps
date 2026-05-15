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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_poly_points = polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
