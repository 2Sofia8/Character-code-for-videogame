extends CanvasLayer
#I followed a tutorial for thisand the guy used signals but they arent actually needed?!??
#signal you_can_transition_now
	
func transition():
	$AnimationPlayer.play("Fade_in") #fade INTO black
	print("fading to black!")
	
func _on_AnimationPlayer_animation_finished(anim_name):
		if anim_name == "Fade_in":
#			print("Emitted U can transition now")
#			emit_signal("you_can_transition_now")
			$AnimationPlayer.play("Fade_out") #Fade OUTOF black
			
		if anim_name == "Fade_out":
			print("I Have finished fading")
