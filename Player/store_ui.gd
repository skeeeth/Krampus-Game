extends CanvasLayer

@export var num_nice_kids_label:Label
@export var num_naughty_kids_label:Label
@export var num_guards_label:Label

func _ready() -> void:
	PlayerVariables.sack_contents_changed.connect(_update_sack_content_labels)
	_update_sack_content_labels()


func _update_sack_content_labels():
	num_nice_kids_label.text = str(PlayerVariables.sack_npc_type_counts[NPC.NPCType.NiceKid])
	num_guards_label.text = str(PlayerVariables.sack_npc_type_counts[NPC.NPCType.Guard])
	num_naughty_kids_label.text = str(PlayerVariables.sack_npc_type_counts[NPC.NPCType.NaughtyKid]) + "/20" #To-do: make the target number of kids an actual variable somewhere
