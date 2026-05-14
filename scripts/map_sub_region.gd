@tool
class_name MAP_SUB_REGION
extends Polygon2D
@export var sub_id:int:
	get():
		return sub_id
	set(value):
		sub_id = value
		print(name,"'s new id value is: ", value)
		 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
