@tool
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@export var new_sprite:AtlasTexture
@export var new_collision_shape:Shape2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D
@export var speed_min:float = 25
@export var speed_max:float = 30
@export var charge_time:float = 0.3
@export var break_time:float = 2
@export var radius:float = 16
var tween:Tween
var shape:Shape2D
@export_tool_button("updade texture") var update = update_tex
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	collision.shape = collision.shape.duplicate()
	
	update_tex()
	handle_gas()
	particles.amount = radius * 4

func update_tex():
	if new_sprite:
		sprite.texture = new_sprite.atlas
		sprite.region_rect = new_sprite.region
	if new_collision_shape:
		collision.shape = new_collision_shape
		collision.shape.radius = 0

func handle_gas(step_2_next:bool = true,min_value:float = speed_min,max_value:float = speed_max,radius_value:float = radius):
	particles.emitting = true
	shape = collision.shape
	if !step_2_next:
		min_value = 0
		max_value = 0
		radius_value = 0
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self).set_ease(Tween.EASE_IN)
	tween.tween_property(shape,"radius",radius_value,charge_time + 2*particles.lifetime)
	tween.parallel().tween_property(particles,"initial_velocity_min",min_value,charge_time)
	tween.parallel().tween_property(particles,"initial_velocity_max",max_value,charge_time)
	await tween.finished
	await get_tree().create_timer(break_time).timeout
	handle_gas(!step_2_next)
	pass

func break_timer(step_2_next:bool):
	particles.emitting = false
	if step_2_next:
		await get_tree().create_timer(break_time).timeout
		handle_gas(false,0,0,0)
		if name == "toxic_gas4":
			print("step_2",name)
	else:
		await get_tree().create_timer(break_time).timeout
		handle_gas(true,speed_min,speed_max,radius)
		if name == "toxic_gas4":
			print("step_1",name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	particles.emitting = !(particles.initial_velocity_max == 0)
	collision.set_deferred("disabled",collision.shape.radius <= radius/4)
