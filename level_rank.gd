extends ColorRect

@onready var text_rank: Label = $TextRank

@export var level_id = 1

@export var lore = false
@export var special_lore = false
@export var text = ""

var frame0 = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame0 and !lore:
		frame0 = false
		
		var rank = DATA.get_level(level_id)
	
		text_rank.text = rank
		
		if rank == "?":
			text_rank.add_theme_color_override("font_color",Color("FFFFFF"))
		elif rank == "P":
			text_rank.add_theme_color_override("font_color",Color("ff00c8"))
		elif rank == "S":
			text_rank.add_theme_color_override("font_color",Color("0384fc"))
		elif rank == "A":
			text_rank.add_theme_color_override("font_color",Color("03fca1"))
		elif rank == "B":
			text_rank.add_theme_color_override("font_color",Color("03fc20"))
		elif rank == "C":
			text_rank.add_theme_color_override("font_color",Color("fcb103"))
		elif rank == "D":
			text_rank.add_theme_color_override("font_color",Color("fc5a03"))
		elif rank == "F":
			text_rank.add_theme_color_override("font_color",Color("fc0303"))
	
	if frame0 and lore and !special_lore:
		
		if DATA.save_data["intel"] >= int(text):
			text_rank.add_theme_color_override("font_color",Color("03fc20"))
		
		text_rank.text = text
		
	elif frame0 and lore and special_lore:
		text_rank.text = text
		
		if DATA.has_P_rank():
			text_rank.add_theme_color_override("font_color",Color("03fc20"))
