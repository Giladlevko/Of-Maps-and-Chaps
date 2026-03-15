@tool
extends StaticBody2D



@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var Kill_zone_shape: CollisionShape2D = $kill_zone/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_spike_object(tex:AtlasTexture,col_shape:Shape2D,kill_shape:Shape2D,kill_zone_offset:Vector2,collosion_offset:Vector2):
	sprite.texture = tex.atlas
	sprite.region_rect = tex.region
	collision_shape.shape = col_shape
	Kill_zone_shape.shape = kill_shape
	Kill_zone_shape.position = kill_zone_offset
	collision_shape.position = collosion_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
