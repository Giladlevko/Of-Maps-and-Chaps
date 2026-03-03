extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("idle")
	owner.velocity.x = 0


func physics_update(_delta: float) -> void:
	owner.anim.play("idle")
	if !owner.can_move:
		if !owner.is_on_floor():
			owner.velocity.y += owner.gravity * _delta
			owner.move_and_slide()
		return
	if (Input.is_action_pressed("left") and !Input.is_action_pressed("right")) or (Input.is_action_pressed("right") and !Input.is_action_pressed("left")):
		if Input.is_action_just_pressed("dash") and owner.can_dash and Global.dash_unlocked:
			finished.emit("dash")
		else:
			finished.emit("run")
	if Input.is_action_just_pressed("jump"):
		finished.emit("jump")
	if !owner.is_on_floor():
		if (owner.is_on_wall()) and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and Global.wall_jump_unlocked:
			finished.emit("wall_jump")
		else: 
			owner.velocity.y += owner.gravity * _delta
	if owner.dead:
		finished.emit("dead")
	owner.move_and_slide()

func exit() -> void:
	pass
