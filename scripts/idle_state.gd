extends State
var cam_up_pos:Vector2 = Vector2(0,-30)
var cam_down_pos:Vector2 = Vector2(0,50)
var cam_base_pos:Vector2 = Vector2(0,0)


func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("idle")


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
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		finished.emit("jump")
	if !owner.is_on_floor():
		if (owner.is_on_wall()) and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and Global.wall_jump_unlocked:
			finished.emit("wall_jump")
		else: 
			owner.velocity.y += owner.gravity * _delta
	else:
		owner.velocity.x = 0
	if owner.dead:
		finished.emit("dead")
	if owner.is_on_floor():
		if Input.is_action_just_pressed("UP"):
			owner.cam.position = cam_up_pos
		elif Input.is_action_just_pressed("DOWN"):
			owner.cam.position = cam_down_pos
	if Input.is_action_just_released("DOWN") or Input.is_action_just_released("UP"):
		owner.cam.position = cam_base_pos
	if Input.is_action_just_pressed("super_dash") and owner.is_on_floor():
		finished.emit("charge_super_dash")
	owner.move_and_slide()


func exit() -> void:
	owner.cam.position = cam_base_pos
	pass
