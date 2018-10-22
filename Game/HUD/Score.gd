extends RichTextLabel

var score = 0

func update_score():
	self.clear()
	self.add_text(str(score))

func _ready():
	update_score()