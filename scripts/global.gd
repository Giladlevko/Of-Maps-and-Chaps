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
var areas_amount: int = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
