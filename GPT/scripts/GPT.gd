extends HTTPRequest


@export
var request_file_path : String # path to json file which contains request details (where prompt is blank)

@export
var path_to_initial_prompt_file : String # path to text file which contains initial prompt

@export
var path_work_file : String # path to working file where all the conversation is stored

signal received(response)

var available = false

var recent_response = "" # most recent response sent from gpt

func _ready() -> void:
	var json = FileAccess.file_exists(request_file_path)
	var work_file = _setup_work_file()
	if(!json || !work_file):
		#llog("Couldn't initialize files, GPT service is unavailable")
		available = false
		return
	
	self.use_threads = true
	self.connect("request_completed", receive_request)
	
	available = true
	
	prompt_gpt("Human: um... Hello? who are you?")


func role_prompt(prompt, role:="Human: "):
	if(prompt.contains("'") || prompt.contains("\\") || prompt.contains("\"")):
		return false
	
	prompt_gpt(role + prompt)
	
	return true

func player_prompt(prompt):
	return role_prompt(prompt)

func command_prompt(prompt):
	return role_prompt(prompt, "")


func llog(text):
	$Label.text = $Label.text + "\n" + str(text)


func prompt_gpt(prompt):
	_work_file_user_append(prompt)
	
	var dict = _get_dictionary_from_json()
	
	dict["prompt"] = _read_from_work_file()
	
	var headers = PackedStringArray()
	headers.append("Content-Type: application/json")
	headers.append("Authorization: Bearer api_key_goes_here")
	
	self.request(
		"https://api.openai.com/v1/completions", 
		headers,
		HTTPClient.METHOD_POST,
		str(dict))
	
	await self.request_completed
	
	_work_file_gpt_append()
	
	if(!recent_response.is_empty()):
		recent_response = recent_response.split(":")[1]
	llog(recent_response)


func _get_dictionary_from_json():
	var dataFile = FileAccess.open(request_file_path, FileAccess.READ)
	var parsed: Dictionary= JSON.parse_string(dataFile.get_as_text())
	dataFile.close()
	return parsed


func receive_request (result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	#llog("response recieved")
	llog(response_code)
	var parsed = JSON.parse_string(body.get_string_from_ascii())
	var response_string = parsed.get("choices")
	
	if(response_code != 200):
		recent_response = ""
		emit_signal("received", response_code)
	else:
		recent_response = response_string[0].get("text")
		emit_signal("received", response_code)



func _setup_work_file() -> bool:
	if !FileAccess.file_exists(path_to_initial_prompt_file):
		return false
	if !FileAccess.file_exists(path_work_file):
		return false
	
	var initial = _read_from_file(path_to_initial_prompt_file)
	_rewrite_file(path_work_file, initial)
	return true
func _read_from_work_file():
	return _read_from_file(path_work_file)
func _work_file_user_append(text):
	_append_to_file(path_work_file, text)
func _work_file_gpt_append():
	_append_to_file(path_work_file, recent_response)


func _append_to_file(file, text):
	var data = FileAccess.open(file, FileAccess.READ_WRITE)
	data.seek_end()
	data.store_string("\n")
	data.store_string(text)
	data.close()
func _read_from_file(file):
	var result = ""
	var data = FileAccess.open(file, FileAccess.READ)
	while not data.eof_reached(): # iterate through all lines until the end of file is reached
		var line = data.get_line()
		result += line + "\n"
	return result
func _rewrite_file(file, text):
	var data = FileAccess.open(file, FileAccess.WRITE)
	data.store_string(text)



var once = true


func _on_received(response) -> void:
	return
	if once:
		prompt_gpt("Human: OW SHIT! SHIT! SHIT! *starts running*")
		once = false



func _on_button_pressed() -> void:
	var prompt:String = $TextEdit.text
	$TextEdit.clear()
	player_prompt(prompt)


func _on_button_2_pressed() -> void:
	var prompt:String = "Human: " + $TextEdit.text
	$TextEdit.clear()
	command_prompt(prompt)

