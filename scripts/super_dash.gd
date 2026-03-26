extends State
var dash_speed:float = 700
var dir: int = 1 
var can_check_wall:bool = true
func enter(previous_state_path: String, data := {}) -> void:
	owner.cam.shake_cam(0)
	owner.cam.position_smoothing_speed = 10
	owner.anim.play("super_dash")
	print(data[0])
	if data[0] == "wall_jump":
		dir = -1*owner.last_dir
		can_check_wall = false

		
	else:
		dir = owner.last_dir
	
	owner.velocity.x = dash_speed * dir
	owner.move_and_slide()
	set_deferred("can_check_wall",true)
	owner.anim.flip_h = (dir ==-1)
	owner.super_dash_particles.position.x = -4*dir
	owner.super_dash_particles.scale.x = -dir
	owner.super_dash_particles.emitting = true

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("super_dash"):
		finished.emit("run")
	elif owner.is_on_wall() and can_check_wall:
		finished.emit("wall_jump")
	owner.move_and_slide()




func exit() -> void:
	owner.cam.position_smoothing_speed = 5
	owner.super_dash_particles.emitting = false
