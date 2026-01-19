extends CharacterBody2D


var player
var player_in_chat_zone = false

func _process(delta):
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		print ("KYS")
		$Dialogue.start()
		GlobalScript.Conductor = true
		
func _on_chatarea_body_entered(body):
		player_in_chat_zone = true


func _on_chatarea_body_exited(body):
		player_in_chat_zone = false
