
extends StaticBody2D
@export var start_pos:Vector2
@export var finish_pos:Vector2
@export var saw_size: float
@export var horizontal:bool = true
@export var speed: int = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move():
	var tween = get_tree().create_tween().bind_node(self).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	var distance:float = abs(start_pos.x - finish_pos.x)
	var time:float = distance/speed
	tween.set_loops()
	tween.tween_property(self,"rotation_degrees",(distance/saw_size)*360,time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"position",finish_pos,time)
	tween.chain()
	tween.tween_property(self,"rotation_degrees",0,time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"position",start_pos,time)
