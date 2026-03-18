extends State
var super_dash_charge_time: float = 3
var fully_charged: bool
var charging: bool = true
var last_state:String
signal bar_finished
var tween: Tween
var dir:int = 1
func enter(previous_state_path: String, data := {}) -> void:
	owner.velocity = Vector2(0,0)
	owner.reset_bar(owner.super_dash_bar)
	handle_super_dash_bar()
	last_state = previous_state_path



func physics_update(_delta: float) -> void:
	if fully_charged:
		if Input.is_action_just_released("super_dash"):
			handle_super_dash_bar(0,0,owner.super_dash_bar.value/super_dash_charge_time,false)
			#transfer to dash
			finished.emit("super_dash")
			owner.move_and_slide()
			
	else:
		if Input.is_action_just_released("super_dash"):
			charging = false
			handle_super_dash_bar(0,0,owner.super_dash_bar.value/super_dash_charge_time)
			finished.emit(last_state)
		
	owner.anim.flip_h = (owner.last_dir == -1)

func handle_super_dash_bar(a_value:float = 1,value:float = super_dash_charge_time,
time:float = super_dash_charge_time,set_parallel:bool = true):
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(owner)
	tween.set_parallel(set_parallel)
	tween.tween_property(owner.super_dash_bar,"value",value,time)
	tween.tween_property(owner.super_dash_bar,"modulate",Color(1,1,1,a_value),0.2)
	bar_finished.emit()
	await tween.finished
	fully_charged = (owner.super_dash_bar.value == super_dash_charge_time)
	


func exit() -> void:
	pass
