extends State



func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("run")


func physics_update(_delta: float) -> void:
	var dir_x = Input.get_axis("left","right")
	owner.velocity.x = owner.speed_x * dir_x
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"): 
		finished.emit("idle")
	if dir_x == 1:
		owner.anim.flip_h = false
	if dir_x == -1:
		owner.anim.flip_h = true
	if Input.is_action_just_pressed("jump"):
		finished.emit("jump")
	if dir_x == 0:
		finished.emit("idle")
	if !owner.is_on_floor():
		if (owner.is_on_wall() or owner.velocity.x == 0) and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
			finished.emit("wall_jump")
		else: 
			owner.velocity.y += owner.gravity * _delta
	owner.move_and_slide()

func exit() -> void:
	pass
