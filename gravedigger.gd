extends CharacterBody2D

const speed = 300
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position

# -------------------------
# ANIMATIONS & STATE LOGIC
# -------------------------
func _process(delta):
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("IDLE")
	elif current_state == MOVE and !is_chatting:
		if dir == Vector2.LEFT:
			$AnimatedSprite2D.play("LEFT")
		elif dir == Vector2.RIGHT:
			$AnimatedSprite2D.play("RIGHT")
		elif dir == Vector2.UP:
			$AnimatedSprite2D.play("FORWARD")
		elif dir == Vector2.DOWN:
			$AnimatedSprite2D.play("BACK")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
			MOVE:
				pass # movement happens in _physics_process()

	if Input.is_action_just_pressed("chat"):
		$GraveDiggerDI.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("IDLE")

# -------------------------
# PHYSICS MOVEMENT (FIX)
# -------------------------
func _physics_process(delta):
	if is_roaming and current_state == MOVE and !is_chatting:
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Stop when hitting TileMap fence
	if is_on_wall():
		velocity = Vector2.ZERO
		current_state = IDLE

# -------------------------
# HELPERS
# -------------------------
func choose(array):
	array.shuffle()
	return array.front()

# -------------------------
# CHAT DETECTION
# -------------------------
func _on_chat_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false

# -------------------------
# ROAM TIMER
# -------------------------
func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1.0, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

# -------------------------
# DIALOGUE FINISHED
# -------------------------
func _on_grave_digger_di_dialogue_finished():
	is_chatting = false
	is_roaming = true
	GlobalScript.grave = true
