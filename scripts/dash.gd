extends State
var dash_speed: int = 1800
func enter(previous_state_path: String, data := {}) -> void:
	owner.can_dash = false
	owner.anim.play("dash")
	owner.velocity.y = 0
	owner.anim.animation_finished.connect(on_anim_finish)


func physics_update(_delta: float) -> void:
	owner.anim.play("dash")
	if !owner.can_move:
		finished.emit("idle")
		return
	var dir_x = Input.get_axis("left","right")
	owner.velocity.x += dash_speed*dir_x * _delta
	owner.move_and_slide()
	if owner.dead:
		finished.emit("dead")

func exit() -> void:
	owner.anim.animation_finished.disconnect(on_anim_finish)

func on_anim_finish():
	if owner.anim.animation == "dash":
		finished.emit("run")
