extends State
var dash_speed:float = 700
var dir: int = 1 

func enter(previous_state_path: String, data := {}) -> void:
	owner.cam.position_smoothing_speed = 10
	owner.anim.play("dash")
	if previous_state_path == "wall_jump":
		dir = -owner.last_dir
	else:
		dir = owner.last_dir
	owner.velocity.x = dash_speed * dir


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("super_dash"):
		finished.emit("run")
	elif owner.is_on_wall():
		finished.emit("wall_jump")
	owner.move_and_slide()


func exit() -> void:
	owner.cam.position_smoothing_speed = 5
