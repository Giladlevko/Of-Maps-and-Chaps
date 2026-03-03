extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.anim.play("dead")
	owner.velocity.x = owner.velocity.x/3
	SignalBus.death_finished.connect(on_death_anim_finished)
	SignalBus.player_died.emit()


func physics_update(_delta: float) -> void:
	if !owner.is_on_floor():
		owner.velocity.y += owner.gravity * _delta
	owner.move_and_slide()



func exit() -> void:
	SignalBus.death_finished.disconnect(on_death_anim_finished)

func on_death_anim_finished():
	await get_tree().create_timer(1).timeout
	owner.cam.position_smoothing_enabled = false
	owner.position = owner.last_pos
	owner.dead = false
	owner.can_dash = true
	owner.cam.set_deferred("position_smoothing_enabled",true)
	finished.emit("idle")
