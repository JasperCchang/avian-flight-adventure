extends Control

var summary_info = {
	0 : { "label" : "Score", "detail" : 0},
	1 : { "label" : "Time", "detail" : 0},
	2 : { "label" : "Amount of tries", "detail" : 0},
	3 : { "label" : "Foods", "detail" : 0},
	4 : { "label" : "Health", "detail" : 0},
	5 : { "label" : "Storm", "detail" : 0},

}

@onready var info_list = $Panel/info_list
#@onready var tutorial_ui_info = $"..".get_node("Tutorial_UI")
@onready var game_info = $".."

# Called when the node enters the scene tree for the first time.
func _ready():

###################### can change if you want ########################
	if  game_info:
		summary_info[0]["detail"] = game_info.score
		summary_info[1]["detail"] = str(int(game_info.time)) + " s"
		summary_info[2]["detail"] = game_info.amount_of_tries
		summary_info[3]["detail"] = game_info.foods
		summary_info[4]["detail"] = game_info.level_1_health
		summary_info[5]["detail"] = game_info.storm
###################################################################

	for i in summary_info:
		var info = Label.new()
		info_list.add_child(info)
		info.text = summary_info[i]["label"] + " : " + str(summary_info[i]["detail"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_pressed():
	get_tree().quit()

func _on_again_pressed():
	get_tree().quit()

func _on_next_pressed():
	get_tree().quit()
