extends AnimatableBody2D
@export var swing_point:float
@export var duration:float
@export_enum("1","-1") var swing_dir:String = "1"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func swing():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops().bind_node(self)
	tween.tween_property(self,"rotation_degrees", int(swing_dir)* swing_point,duration)
	tween.tween_property(self,"rotation_degrees",-int(swing_dir) * swing_point,duration)
	pass
