extends AnimatableBody2D
@export var start_pos:Vector2 = Vector2(0,0)
@export var finish_pos:Vector2 = Vector2(100,0)
@export var speed: float = 5
var duration: float
@export var plat_tex: Texture
@export var coll_shape: Shape2D
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $Collision_shape
@export var horizantal:bool = true
@export var platform_id:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if horizantal:
		duration = abs((finish_pos.x - start_pos.x)/speed)
	else:
		duration = abs((finish_pos.y - start_pos.y)/speed)
	
	if plat_tex:
		sprite.texture = plat_tex
	if coll_shape:
		collision_shape.shape = coll_shape
	move_platform()
	SignalBus.unlock_platform.connect(on_unlock_platform)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func move_platform() -> void:
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).bind_node(self)
	tween.tween_property(self,"global_position",finish_pos,duration)
	
	tween.chain().tween_property(self,"global_position",start_pos,duration)
	await tween.finished
	move_platform()
	

func on_unlock_platform(value:int):
	if platform_id == value:
		visible = true
		SignalBus.message_popup.emit("New Platform Unlocked!")
