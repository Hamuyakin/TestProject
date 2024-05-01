extends Node2D

signal player_at_entrance(entrance_tag, entrance_direction)

var sprites = {0 : AnimatedSprite2D, 1 : AnimatedSprite2D, 2 : AnimatedSprite2D} # Спрайты дверей
var items = {0 : Area2D, 1 : Area2D} # Предметы на улице

@onready var main : Node2D = get_parent() # Основная сцена


# Получение референсов к спрайтам всех входов
func get_sprites():
	sprites = {
		0 : get_node("Entrance0/AnimatedSprite2D"),
		1 : get_node("Entrance1/AnimatedSprite2D"),
		2 : get_node("Entrance2/AnimatedSprite2D")
	}


# Поиск референсов ко всем существующим предметам
func get_items():
	items = {
		0 : get_node("Item0"),
		1 : get_node("Item1")
	}


# Обновление спрайтов дверей (открыто/закрыто)
func update_door_sprites(door_states):
	get_sprites()
	for sprite_index in sprites:
		if door_states[sprite_index] == 0: 
			sprites[sprite_index].animation = "open"
		else: 
			sprites[sprite_index].animation = "closed"


# Обновление состояний предметов
func update_item_states(item_states):
	get_items()
	for item in items:
		if item_states[item] == 0:
			items[item].queue_free()


func _on_entrance_player_at_entrance(entrance_tag, entrance_direction):
	player_at_entrance.emit(entrance_tag, entrance_direction)

func _on_item_picked_up_by_player(item_index):
	main.street_item_states[item_index] = 0
