extends Control

@export var mag_capacity = 30
@onready var bullets = mag_capacity
@export var rpm = 600
@export var full_auto = false

var time_to_empty = 0
var shoot_timer = 0
var prev_bullet_time = 0
@onready var rof = 0.1 		# 1 / (rpm / 60)

signal fire_ready


func _input(event):
	if event.is_action_pressed("fire"):
		shoot()
	if event.is_action_pressed("reload"):
		reload()


func _physics_process(delta):
	shoot_timer += delta
	if shoot_timer >= (prev_bullet_time + rof):
		fire_ready.emit()
	if (Input.is_action_pressed("fire") && bullets > 0):
		time_to_empty += delta
	update_ui()


func shoot():
	if shoot_timer < (prev_bullet_time + rof) || bullets <= 0:
		return
	
	prev_bullet_time = shoot_timer
	bullets -= 1
	await fire_ready
	if full_auto && Input.is_action_pressed("fire"):
		shoot()


func reload():
	bullets = mag_capacity
	time_to_empty = 0


func update_ui():
	$BulletsLeft.text = str(bullets)
	$TimeToEmpty.text = str("%.3f" % time_to_empty)
