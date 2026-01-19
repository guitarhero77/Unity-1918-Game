extends Node2D

func _ready():
	$NinePatchRect.visible = false
	if GlobalScript.Conductor and GlobalScript.Bea and GlobalScript.cloth and GlobalScript.grave.is_true():
		$NinePatchRect.visible = true
		
