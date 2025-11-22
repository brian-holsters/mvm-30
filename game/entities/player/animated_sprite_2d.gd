extends AnimatedSprite2D

func _on_frame_changed() -> void:
	#print(animation)
	if animation == "walk":
		if (frame == 1) or (frame == 5):
			%FootstepsAudio.play()
			
	if animation == "land":
		if (frame == 0):
			%LandingAudio.play()
