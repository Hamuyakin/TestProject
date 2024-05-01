extends StaticBody2D

@export var text : String # Текст объекта, можно изменять в инспекторе
@export var sprite : int = 0 # Спрайт объекта
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_interactable : bool = false # Возможность взаимодействия с объектом
var player : CharacterBody2D

@onready var hud = get_tree().get_first_node_in_group("HUD")

func _ready():
	animated_sprite_2d.frame = sprite


func _physics_process(_delta):
	# Взаимодействовать с объектом можно только когда игрок смотрит на него
	if Input.is_action_just_pressed("interact") && is_interactable:
		if player.global_position.x >= self.global_position.x:
			if player.looking_direction == Vector2(1, 0): return
		if player.global_position.x < self.global_position.x:
			if player.looking_direction == Vector2(-1, 0): return
		if player.global_position.y >= self.global_position.y:
			if player.looking_direction == Vector2(0, 1): return
		if player.global_position.y < self.global_position.y:
			if player.looking_direction == Vector2(0, -1): return
		interact()


# Включает отображение контекстного интерфейса
func interact():
	hud.show_dialogue(text)


# Игрок входит в зону взаимодействия с объектом
func _on_interaction_zone_body_entered(body):
	if body is CharacterBody2D:
		is_interactable = true
		player = body


# Игрок выходит из зоны взаимодействия с объектом
func _on_interaction_zone_body_exited(body):
	if body is CharacterBody2D:
		is_interactable = false
		player = null
		hud.hide_dialogue()
