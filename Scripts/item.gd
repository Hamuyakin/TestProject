extends Area2D

@export var type : String = "key" # Тип предмета (по умолчанию - ключ)
@export var index : int # Индекс предмета в данной комнате
@export var sprite : int = 0 # Спрайт предмета (по умолчанию - ключ)
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var main = get_tree().get_first_node_in_group("main") # Основная сцена

func _ready():
	animated_sprite_2d.frame = sprite

signal picked_up_by_player(item_index)


# Функция срабатывает, когда игрок наступает на предмет
# В зависимости от типа предметов, происходит разный эффект
func _on_body_entered(body):
	if body is CharacterBody2D:
		if type == "key":
			body.keys += 1
		elif type == "pepper":
			body.current_health -= 1
		elif type == "apple":
			body.current_health += 1
		elif type == "orange":
			body.max_health += 1
			body.current_health += 1
		elif type == "olives":
			body.max_health -= 10
		elif type == "alarm":
			main.reset_door_states()
		body.item_gained.emit(type)
		picked_up_by_player.emit(index)
		queue_free() # После подбора предмет удаляется
