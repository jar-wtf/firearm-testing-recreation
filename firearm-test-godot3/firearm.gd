extends Spatial


export var mag_capacity = 30
onready var bullets = mag_capacity
export var rpm: int = 600
export var full_auto = false

var time_to_empty = 0
var shoot_timer = 0
var prev_bullet_time = 0
onready var rof: float = 1 / (rpm / 60.0)


func _process(_delta):
	if Input.is_action_pressed("fire") && full_auto:
		shoot()


func _input(event):
	if event.is_action_pressed("fire") && !full_auto:
		shoot()
	if event.is_action_pressed("reload"):
		reload()


func _physics_process(delta):
	shoot_timer += delta
	if (Input.is_action_pressed("fire") && bullets > 0):
		time_to_empty += delta
	update_ui()


func shoot():
	if shoot_timer < (prev_bullet_time + rof) || bullets <= 0:
		return
	
	prev_bullet_time = shoot_timer
	bullets -= 1


func reload():
	bullets = mag_capacity
	time_to_empty = 0


func update_ui():
	$Control/VBoxContainer/BulletsLeft.text = str(bullets)
	$Control/VBoxContainer/TimeToEmpty.text = str("%.3f" % time_to_empty)
#	$Control/VBoxContainer/TimeToEmpty.text = str(time_to_empty)
