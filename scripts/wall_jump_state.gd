extends State
var look_dir_x: int = 1

func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("wall_slide")
	owner.velocity.y = owner.velocity.y/20
	owner.velocity.x = 0
	


func update(_delta: float) -> void:
	var dir_x = Input.get_axis("left","right")
	var velocity_weight_x: float = 0.7
	owner.move_and_slide()
	if owner.is_on_floor():
		finished.emit("idle")
		return
	if owner.wall_jump_lock > 0.0:
		owner.wall_jump_lock -= _delta
		owner.velocity.x = lerp(owner.velocity.x,dir_x*owner.speed_x,velocity_weight_x*0.5)
	else:
		owner.velocity.x = lerp(owner.velocity.x,dir_x * owner.speed_x,velocity_weight_x)
	if !owner.is_on_floor() and owner.velocity.y > 0 and owner.is_on_wall() and owner.velocity.x != 0:
		look_dir_x = sign(owner.velocity.x)
		owner.wall_contact_coyote = owner.wall_contact_coyote_time
		owner.velocity.y += owner.gravity_wall * _delta
		owner.anim.play("wall_slide")
	else:
		owner.wall_contact_coyote -= _delta
		owner.velocity.y += owner.gravity * _delta
	if owner.wall_contact_coyote > 0.0:
		if Input.is_action_just_pressed("jump"):
			owner.anim.play("jump")
			owner.velocity.y += owner.speed_y * 1.1
			owner.velocity.x = - look_dir_x * owner.wall_push_force
			owner.wall_jump_lock = owner.wall_jump_lock_time
	
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"): 
		dir_x = 0
	if dir_x == 1:
		owner.anim.flip_h = false
	if dir_x == -1:
		owner.anim.flip_h = true

func exit() -> void:
	pass
