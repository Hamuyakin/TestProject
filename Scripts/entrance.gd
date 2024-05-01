extends Node2D

@export var index : int # Индекс входа
@export var direction : String # Направление входа

var is_openable : bool = false # Возможно ли отпереть дверь

signal player_at_entrance(entrance_index, entrance_direction)

@onready var main = get_tree().get_first_node_in_group("main") # Основная сцена
@onready var hud = get_tree().get_first_node_in_group("HUD") # Интерфейс


# Функция срабатывает при входе игрока в зону взаимодействия
func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		player_at_entrance.emit(index, direction)
		if body.keys != 0: is_openable = true # Если у игрока есть ключ, дверь можно открыть


# Функция срабатывает при выходе игрока из зоны взаимодействия
func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		is_openable = false # Дверь, от которой игрок отошел, больше нельзя открыть
		hud.hide_dialogue()


# Функция отпирания двери
func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") && is_openable :
		main.open_door(index)
