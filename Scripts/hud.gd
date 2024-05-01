extends CanvasLayer

@onready var label_1 = $Stats/VBoxContainer/Label1 # Интерфейс отображения здоровья
@onready var label_2 = $Stats/VBoxContainer/Label2 # Интерфейс отображения ключей

@onready var dialogue = $Dialogue # Интерфейс отображения контекстной информации
@onready var dialogue_label = $Dialogue/DialogueLabel # Текст контекстной информации
@onready var timer = $Dialogue/Timer # Таймер отключения контекстного интерфейса


# Обновление данных о здоровье
func update_health(max_health, current_health):
	label_1.text = "HP: " + str(current_health) + "/" + str(max_health)


# Обновление данных о ключах
func update_key_count(keys):
	label_2.text = "KEYS: " + str(keys)


# Включение интерфейса контекстной информации
func show_dialogue(text):
	timer.start()
	dialogue_label.text = text
	dialogue.show()

func hide_dialogue():
	dialogue.hide()


func _on_timer_timeout():
	hide_dialogue()
