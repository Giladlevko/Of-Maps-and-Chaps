@tool
extends Area2D
@export var speed_x:float
@export var speed_y:float
@export var particle_rotation:float
@onready var particles: CPUParticles2D = $sprites/CPUParticles2D
@export_tool_button("update_particle") var update:Callable = update_particles
var player_grav_accel: float = 900.0
var finale_player_speed:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_particles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		
		body.velocity = Vector2(speed_x,-speed_y)
		var tween = get_tree().create_tween().bind_node(self).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self,"scale",Vector2(1.3,0.8),0.1)
		tween.tween_property(self,"scale",Vector2(1,1),0.1)
		

func update_particles():
	if speed_y !=0 and abs(speed_y) > abs(speed_x):
		if speed_x > 0:
			particles.rotation_degrees = -30
		elif speed_x < 0:
			particles.rotation_degrees = -150
		else:
			particles.rotation_degrees = -90
	else:
		if speed_x > 0:
			particles.rotation_degrees = 0
		elif speed_x < 0:
			particles.rotation_degrees = 180
	var speed:float
	if speed_y !=0 and abs(speed_y) > abs(speed_x):
		speed = speed_y
	else: speed = speed_x
	var t_to_top:float = (speed)/player_grav_accel
	var average_speed:float = (speed + finale_player_speed)/2
	var distance:float = t_to_top * average_speed
	var particle_speed:float = abs(distance/particles.lifetime)
	particles.initial_velocity_min = particle_speed
	particles.initial_velocity_max = particle_speed
	particles.amount = clamp(abs(particle_speed)/4,8,48)
