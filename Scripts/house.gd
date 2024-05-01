extends Node2D

@export var house_index : int # Индекс дома

var items = {0 : Area2D, 1 : Area2D} # Словарь подбираемых предметов в данном доме

@onready var main : Node2D = get_parent() # Основная сцена

signal player_at_entrance(entrance_index, entrance_direction)

func _on_entrance_player_at_entrance(entrance_index, entrance_direction):
	player_at_entrance.emit(entrance_index, entrance_direction) 


# Поиск референсов ко всем существующим предметам
func get_items():
	items = {
		0 : get_node("Item0"),
		1 : get_node("Item1"),
		2 : get_node("Item2")
	}


# Обновление состояний предметов
func update_item_states(item_states):
	get_items()
	for item in items:
		if item_states[item] == 0:
			items[item].queue_free()


# Срабатывает при подборе предмета игроком
func _on_item_picked_up_by_player(item_index):
	# Если игра только что перезапущена, предмет не удаляется
	if main.game_just_reset: 
		main.game_just_reset = false
	# В противном случае, предмет отмечается в базе данных как отсутствующий
	else:
		main.house_item_states[house_index][item_index] = 0
