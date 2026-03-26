extends State
var super_dash_charge_time: float = 3
var fully_charged: bool
var charging: bool = true
var last_state:String
signal bar_finished
var tween: Tween
var dir:int = 1
var cam_shake_amount:float = 1
func enter(previous_state_path: String, data := {}) -> void:
	
	cam_shake_amount = 1
	dir = owner.last_dir
	owner.velocity = Vector2(0,0)
	owner.reset_bar(owner.super_dash_bar)
	handle_super_dash_bar()
	last_state = previous_state_path
	handle_last_state()
	owner.dash_charge_particles.emitting = true
	fully_charged = false

func physics_update(_delta: float) -> void:
	if fully_charged:
		owner.super_dash_bar.get_theme_stylebox("fill").border_color = Color(1,1,1,1)
		if Input.is_action_just_released("super_dash"):
			handle_super_dash_bar(0,0,owner.super_dash_bar.value/super_dash_charge_time,false)
			#transfer to dash
			finished.emit("super_dash",{0:last_state})
			return
			
	else:
		if Input.is_action_just_released("super_dash"):
			charging = false
			handle_super_dash_bar(0,0,owner.super_dash_bar.value/(super_dash_charge_time*10))
			finished.emit(last_state)
			
			return
	cam_shake_amount =clamp(cam_shake_amount+1*_delta,0,7)
	owner.cam.shake_cam(cam_shake_amount)
	dir = owner.last_dir
	owner.anim.flip_h = (dir == -1)

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
	

func handle_last_state():
	if last_state == "wall_jump":
		owner.dash_charge_particles.rotation_degrees = 180 
		owner.dash_charge_particles.scale.x = 1*dir
		owner.dash_charge_particles.position.x = -3*dir
		
	else:
		owner.anim.play("charge_super_dash")
		owner.dash_charge_particles.position.x = 0
		owner.dash_charge_particles.rotation_degrees = -90
		owner.dash_charge_particles.scale.x = 1

func exit() -> void:
	owner.dash_charge_particles.emitting = false
	owner.dash_charge_particles.scale.x = 1
	owner.super_dash_bar.get_theme_stylebox("fill").border_color = Color(0.263, 0.875, 1.0)
