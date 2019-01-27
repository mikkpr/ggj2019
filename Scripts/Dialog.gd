extends Node

func _ready():
	announce("")
	mother_say("")

func _get_announcement_text_node():
	return find_node("Announcement")

func _get_mother_text_node():
	return find_node("Mother")
	   
func announce(text):
	var label = _get_announcement_text_node()
	label.text = text
	_clear_label_after_seconds(label, 3)

func mother_say(text):
	var label = _get_mother_text_node()
	label.text = text
	_clear_label_after_seconds(label, 3)
	   
func _clear_label_after_seconds(label, seconds):
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	label.text = ""
	t.queue_free()
