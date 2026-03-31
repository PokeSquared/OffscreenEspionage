extends Node

var resource: String = ""

var allowprocess = false

func _process(delta: float) -> void:
	
	if allowprocess:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(resource, progress)
			
		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var level = ResourceLoader.load_threaded_get(resource)
		
			level = level.instantiate()
			
			var tree = get_tree()
			var cur_scene = tree.get_current_scene()
			tree.get_root().add_child(level)
			tree.get_root().remove_child(cur_scene)
			tree.set_current_scene(level)
			allowprocess = false

func loadlevel(to_load):
	resource = to_load
	ResourceLoader.load_threaded_request(resource)
	
func switch_to_current():
	allowprocess = true
