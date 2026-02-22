extends Node

var ink_amount:int = 0
var max_ink:int = 10
var correct_skulls: Array = []
var skulls_can_give: bool = true
var wall_jump_unlocked:bool = false
var dash_unlocked: bool = false
var super_dash_unlocked:bool
var double_jump_unlocked:bool
var reached_check_points:Array = []
var updated_areas:Array = []
var areas_amount: int = 12
var not_updated_map_visited_areas:Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
