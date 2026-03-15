@tool
extends Area2D
@export var shape: Shape2D
@export var damage_object_scene: PackedScene
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var Y_based:bool
@export var turn_if_y_based: bool = true
@export var spacing:int = 16
@export_enum("1","-1") var dir_x = "1"
@export var spike_tex:AtlasTexture
@export var spike_col:Shape2D
@export var spike_kill_shape:Shape2D
@export var kill_shape_offset:Vector2
@export var collision_offset:Vector2
@export_tool_button("update shape") var update_button = update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	collision_shape.shape = shape
	for child in collision_shape.get_children():
		child.queue_free()
	
	
	if Y_based:
		var damage_object_count: int = floor(collision_shape.shape.size.y / spacing)
		for damage_object_index in damage_object_count:
			var DAMAGE_OBJECT = damage_object_scene.instantiate()
			DAMAGE_OBJECT.position.y = -spacing * damage_object_index + collision_shape.shape.size.y/2 - spacing/2
			if turn_if_y_based:
				DAMAGE_OBJECT.rotation_degrees = 90
			scale.x = int(dir_x)
			collision_shape.add_child(DAMAGE_OBJECT)
			DAMAGE_OBJECT.update_spike_object(spike_tex,spike_col,spike_kill_shape,kill_shape_offset,collision_offset)
			
	else:
		var damage_object_count: int = floor(collision_shape.shape.size.x / spacing)
		for damage_object_index in damage_object_count:
			var DAMAGE_OBJECT = damage_object_scene.instantiate()
			DAMAGE_OBJECT.position.x = spacing * damage_object_index - collision_shape.shape.size.x/2 + spacing/2
			collision_shape.add_child(DAMAGE_OBJECT)
			DAMAGE_OBJECT.update_spike_object(spike_tex,spike_col,spike_kill_shape,kill_shape_offset,collision_offset)
	
