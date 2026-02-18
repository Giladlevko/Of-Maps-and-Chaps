extends State
var wall_jump:bool
func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("jump")
	owner.velocity.y += owner.speed_y
	if previous_state_path == "wall_jump":
		wall_jump = true


func physics_update(_delta: float) -> void:
	owner.anim.play("jump")
	var dir_x = Input.get_axis("left","right")
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"): 
		dir_x = 0
	
	if !wall_jump:
		owner.velocity.x = owner.speed_x * dir_x
	else: owner.velocity.x = owner.speed_x * dir_x/2
	owner.velocity.y += owner.gravity * _delta
	if dir_x == 1:
		owner.anim.flip_h = false
	if dir_x == -1:
		owner.anim.flip_h = true
	owner.move_and_slide()
	if owner.is_on_floor():
		if dir_x == 0:
			finished.emit("idle")
		else: finished.emit("run")
	if owner.is_on_wall():
		
		finished.emit("wall_jump")

func exit() -> void:
	pass
