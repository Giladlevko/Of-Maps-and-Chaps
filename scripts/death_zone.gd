@tool
extends Area2D
@export var shape: Shape2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export_tool_button("update shape") var update_button = update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	collision_shape.shape = shape
