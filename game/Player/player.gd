# wall jump; dash

# https://www.youtube-nocookie.com/embed/9u59U-DWNJs?playlist=9u59U-DWNJs&autoplay=1&iv_load_policy=3&loop=1&start=

extends CharacterBody2D

var speed: float = 150.0
var jump_velocity: float = -300.0
var facing_right: bool = true
var jump_amount: int = 1
var acceleration: float = 500.0

var is_dashing: bool = false
var dashing_amount: int = 1
var dash_speed: float = 500.0

var is_sprinting: bool = false
var sprint_acceleration: float = 100.0

var wall_slide: float = 50.0
var wall_x_force: float = 300.0
var wall_y_force: float = -220.0
var is_wall_jumping: bool = false
@onready var wall_jump_ray: RayCast2D = $Ray_cast/ray

func _ready() -> void:
	velocity.y = 200.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		jump_amount = 0
	elif is_on_floor():
		jump_amount = 1
		dashing_amount = 1
	
	animations()
	flip()
	move_and_slide()
	
	if Input.is_action_just_pressed("jump") and jump_amount > 0: # jump
		velocity.y = jump_velocity
		jump_amount -= 1
		print("jump")
	
	var direction := Input.get_axis("left", "right") # droite/gauche
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	while Input.is_action_pressed("sprint"): # Sprint
		if velocity.x != 0:
			if facing_right == true :
				velocity.x += 100.0
			elif facing_right == false :
				velocity.x -= 100.0
	
	if is_on_wall_only(): # wall jump --> a regler
		velocity.y = wall_slide
		if Input.is_action_just_pressed("jump") and is_wall_jumping == false:
			wall_logic()
	
	if Input.is_action_just_pressed("dash"):
		dash_cloak()
	
	if Input.is_action_just_pressed("test"):
		print("turn in console")


func animations():
	if velocity.x != 0:
		$AnimationPlayer.play("move")
	elif velocity.x == 0:
		$AnimationPlayer.play("idle")
	elif is_sprinting == true:
		$AnimationPlayer.play("sprint")

func flip():
	if velocity.x > 0.0:
		facing_right = true
		scale.x = scale.y * 1
		while is_sprinting == true:
			velocity.x = speed + sprint_acceleration
	elif velocity.x < 0.0:
		facing_right = false
		scale.x = scale.y * -1
		while is_sprinting == true:
			velocity.x = speed - sprint_acceleration

func wall_logic():
	if wall_jump_ray.is_colliding():
		if facing_right == true:
			velocity = Vector2(-500.0, -300.0)
		elif facing_right == false:
			velocity = Vector2(500.0, -300.0)
		wall_jummping()
		print("wall jump")

func wall_jummping():
	is_wall_jumping = true
	await get_tree().create_timer(0.3).timeout
	is_wall_jumping = false

func dash():
	if dashing_amount > 0:
		if facing_right == true:
			velocity.x = dash_speed
			await get_tree().create_timer(1).timeout
		elif facing_right == false:
			velocity.x = -dash_speed
			await get_tree().create_timer(1).timeout
		

func dash_cloak():
	velocity.y = 0.0
	is_dashing = true
	dash()
	await get_tree().create_timer(1).timeout
	velocity.y = 200.0
	is_dashing = false

func fight():
	pass
