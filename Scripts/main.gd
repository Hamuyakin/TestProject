extends Node2D

# Упаковыванные сцены, которые будут использоваться в игре
const STREET = preload("res://Scenes/street.tscn")
const FIRST_HOUSE = preload("res://Scenes/first_house.tscn")
const SECOND_HOUSE = preload("res://Scenes/second_house.tscn")
const THIRD_HOUSE = preload("res://Scenes/third_house.tscn")

# Словарь упакованных сцен интерьеров домов
const HOUSES = {0 : FIRST_HOUSE, 1 : SECOND_HOUSE, 2 : THIRD_HOUSE}
# Словарь названий маркеров, отображающих выходы из домов
const EXITS = {0 : "Exit0", 1 : "Exit1", 2 : "Exit2"}

var current_scene : Node # Текущая сцена
var door_states : Array # Текущие состояния дверей (открыто = 0, закрыто = 1)
var street_item_states : Array # Текущие состояния предметов на улице (подобран = 0, не подобран = 1)
var house_item_states : Dictionary # Текущие состояния предметов в каждом доме

@onready var player = %Player
@onready var hud = %HUD

var game_just_reset : bool = false

func _ready():
	full_game_reset()
	game_just_reset = false

# Полный перезапуск игры
func full_game_reset():
	player.stats_reset()
	change_scene(STREET) # Текущая сцена меняется на стартовую - "Улица"
	player.global_position = current_scene.get_node("Spawn").global_position # Переноc игрока на стартовую позицию улицы
	
	reset_door_states()
	reset_item_states()
	
	hud.update_health(player.max_health, player.current_health)
	hud.update_key_count(player.keys)
	
	game_just_reset = true


func reset_item_states():
	street_item_states = [1, 1]
	house_item_states.clear()
	for i in range(3):
		house_item_states[i] = [1, 1, 1]
	print("reset")


func reset_door_states():
	door_states = [1, 1, 1]


# Функция изменения текущей сцены
func change_scene(new_scene):
	if current_scene: current_scene.call_deferred("queue_free") # Удаление текущей сцены
	current_scene = new_scene.instantiate() # Создание экземпляра новой сцены 
	call_deferred("add_child", current_scene) # Добавление новой сцены в иерархию
	
	#Связь сигнала, поступающего от новой сцены, с основным скриптом
	current_scene.player_at_entrance.connect(_on_player_at_entrance)


# Функция перехода игрока между сценами
# Если игрок входит в дом - то он окажется в точке спавна этой сцены
# Если выходит из дома - то окажется у выхода, соответствующего данному дому
func go_through_entrance(direction, entrance_index):
	if direction == "in":
		change_scene(HOUSES[entrance_index])
		player.global_position = current_scene.get_node("Spawn").global_position
		current_scene.update_item_states(house_item_states[entrance_index])
	elif direction == "out":
		change_scene(STREET)
		player.global_position = current_scene.get_node(EXITS[entrance_index]).global_position
		current_scene.update_door_sprites(door_states)
		current_scene.update_item_states(street_item_states)


# функция срабатывает, когда игрок находится у одного из входов/выходов
func _on_player_at_entrance(entrance_index, entrance_direction):
	# Из дома всегда можно выйти беспрепятственно, даже если нет ключа
	if entrance_direction == "out": 
		go_through_entrance(entrance_direction, entrance_index)
		return
	# Если дверь закрыта и нет ключа, пройти не получится
	if door_states[entrance_index] == 1 && player.keys == 0: return
	# Если дверь закрыта но есть ключ, предлагается возможность открыть дверь
	elif door_states[entrance_index] == 1 && player.keys > 0:
		hud.show_dialogue("Spend a key to open?")
	# Если дверь открыта, можно свободно пройти
	elif door_states[entrance_index] == 0:
		go_through_entrance(entrance_direction, entrance_index)


# Функция отпирания двери и прохода через нее
func open_door(entrance_index):
	player.keys -= 1
	hud.update_key_count(player.keys)
	door_states[entrance_index] = 0
	current_scene.update_door_sprites(door_states) # Меняем спрайт двери на открытый
	go_through_entrance("in", entrance_index)


# Функция срабатывает, когда игрок подбирает предмет
func _on_player_item_gained(item):
	hud.show_dialogue("Found " + item + "!")
	player.current_health = clamp(player.current_health, 0, player.max_health) # Ограничение на максимальное и минимальное здоровье игрока
	hud.update_health(player.max_health, player.current_health)
	# Условие проигрыша
	if player.current_health == 0:
		hud.show_dialogue("You ran out of health. Try again!")
		full_game_reset()
	# Сбор ключей
	if item == "key":
		hud.update_key_count(player.keys)
