extends Node2D

@export var level = "res://levels/level1.tscn"
@onready var level_scroll: ScrollContainer = %LevelScroll
@onready var lore_scroll: ScrollContainer = %LoreScroll
@onready var lore_text: Label = %LoreText

@export var function = 0
@export var lore = 0

func clicked():
	
	if function == 0:
		SceneChanger.loadlevel(level)
		SceneChanger.switch_to_current()
	elif function == 1:
		
		DATA.save_game()
		
		get_tree().quit()
	elif function == 2:
		
		if (level_scroll.visible):
			level_scroll.process_mode = Node.PROCESS_MODE_DISABLED
			level_scroll.visible = false
			
			lore_scroll.process_mode = Node.PROCESS_MODE_INHERIT
			lore_scroll.visible = true
			
			lore_text.visible = true
		else:
			level_scroll.process_mode = Node.PROCESS_MODE_INHERIT
			level_scroll.visible = true
			
			lore_scroll.process_mode = Node.PROCESS_MODE_DISABLED
			lore_scroll.visible = false
			
			lore_text.visible = false
	elif function == 3:
		
		var levelrank = get_parent().get_child(3)
		
		if levelrank.lore and !levelrank.special_lore:
			
			if DATA.save_data["intel"] >= int(levelrank.text):
				if lore == 0:
					lore_text.text = "MISSION:\nGo through an abandoned facility overrun by robots. These robots will KILL ON SIGHT. Avoid them by walking through the border of reality. Mark each robot you find with a electro-bomb, so we can safely dismantle every robot and send a squad in.\n\nWe are counting on you Z."
				if lore == 1:
					lore_text.text = "The WTW Project has run into several roadblocks along its way, however I believe we are near a point where we can wake it up. I believe its power should begin to show soon. \n-X"
				elif lore == 2:
					lore_text.text = "Initial reports of it's power has been showing great progress from the first iteration. I have personally noted that it seems to have a very small depth of field. \n-X"
				elif lore == 3:
					lore_text.text = "The Walk-Through-Walls project has been a complete success! It has shown an innate ability to walk through the border of reality. We aren't 100% sure however where it goes once it walks through the borders. All we know is that it always returns. \n-X"
				elif lore == 4:
					lore_text.text = "My Creation has escaped. It escaped from the lab. I do not know how this happened. please don't pull funding... I have something in the works that is also good- not AS good as the WTW project but... I still need funding. \n-X"
				elif lore == 5:
					lore_text.text = "What do you mean my robots are not worth any funding? Damn you. I will guard every single room in this facility to show how strong they are. Once I lead my creation here... you will HAVE TO GIVE ME money... for my next project. \n-X"
				elif lore == 6:
					lore_text.text = "Congratulations my... creation.\nIf you truly wish to know the truth, the gates have opened.\nThis is my final note. My Magnum Opus... the culmination of 13 years of research. The WTW project has been succesful... perhaps too much.\nIf you are reading this, you are the culmination of that project. The one with the ability to walk through the borders of reality.\nI have hidden this final note inside of a borded up room, completely sealed off. If you have this note, it is meant for you.\n-X"
		elif levelrank.lore and levelrank.special_lore:
			if lore == 7 and DATA.has_P_rank():
				lore_text.text = "congrats man\nyou beat the hardest challenge.\nP ranks on EVERY LEVEL is crazy bro\nfor this... you get the Jam's ONE BIG WORD. it is in a new secret level.\nfigured if you wanted the F word I'd make ya work for it."
