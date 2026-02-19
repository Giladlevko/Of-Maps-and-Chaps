extends CharacterBody2D
class_name Player
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var gravity:int = 900
var speed_x:int = 100
var speed_y:int = -200
var gravity_wall:int = 20
var wall_push_force: int = 200
var wall_contact_coyote:float = 0.0
var wall_jump_lock: float = 0.0
var wall_jump_lock_time:float = 0.05
var wall_contact_coyote_time:float = 0.1
var last_pos:Vector2
var dead:bool
const Y_THRESHOLD:int = 1000
@onready var cam: Camera2D = $Camera2D

@onready var popup: PopupPanel = $Popup
var can_dash:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.death_finished.connect(on_death_anim_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !dead:
		if position.y >= Y_THRESHOLD:
			on_dead()
	
	pass


func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		popup.popup()


func _on_interact_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		popup.hide()


func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("interactable"):
		popup.popup()
	if area.is_in_group("check_points"):
		last_pos = area.position
	if area.is_in_group("kills"):
		on_dead()

func _on_interact_zone_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("interactable"):
		popup.hide()

func on_dead():
	dead = true
	SignalBus.player_died.emit()
	
	

func on_death_anim_finished():
	await get_tree().create_timer(0.5).timeout
	cam.position_smoothing_enabled = false
	position = last_pos
	dead = false
	cam.set_deferred("position_smoothing_enabled",true)


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "dash":
		await get_tree().create_timer(2).timeout
		can_dash = true
