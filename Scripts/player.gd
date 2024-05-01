extends CharacterBody2D

var movement_speed : int = 100 # Скорость передвижения
var movement_direction : Vector2 # Направление движения

var last_direction : String # Последнее направление перед тем, как игрок остановился
var looking_direction : Vector2 # Текущее направление взгляда

var max_health : int = 10 # Максимальное здоровье
var current_health : int = max_health # Текущее здоровье

var keys : int = 0 # Количество ключей у игрока

@onready var animated_sprite_2d = $AnimatedSprite2D

signal item_gained(item)

func _physics_process(_delta):
	handle_input()
	move_and_slide()
	update_animations()


# Возвращение характеристик игрока к исходным значениям
func stats_reset():
	max_health = 10
	current_health = max_health
	keys = 0


# Перевод ввода игрока в движение персонажа
func handle_input():
	movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		movement_direction.y = 0
	elif Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down"):
		movement_direction.x = 0
	else:
		movement_direction = Vector2.ZERO
	velocity = (movement_direction.normalized() * movement_speed)


# Анимация спрайта игрока в зависимости от направления движения
func update_animations():
	if velocity.length() == 0:
		last_direction = animated_sprite_2d.animation
		match last_direction:
			"move_right":
				looking_direction = Vector2(1,0)
			"move_left":
				looking_direction = Vector2(-1,0)
			"move_up":
				looking_direction = Vector2(0,-1)
			"move_down":
				looking_direction = Vector2(0,1)
		animated_sprite_2d.stop()
	else:
		if velocity.x < 0: animated_sprite_2d.play("move_left")
		elif velocity.x > 0: animated_sprite_2d.play("move_right")
		elif velocity.y < 0: animated_sprite_2d.play("move_up")
		else: animated_sprite_2d.play("move_down")
