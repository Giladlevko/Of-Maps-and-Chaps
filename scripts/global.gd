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
var current_dialog_id:int = 3
##(left:x,top:y,right:z,bottom:w)
var cam_bounds:Vector4 = Vector4(-1000000,-1000000,1000000,350):
	set(value):
		SignalBus.update_cam_bounds.emit(value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
