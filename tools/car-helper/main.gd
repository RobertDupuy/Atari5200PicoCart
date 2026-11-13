extends Control
const Car = preload("res://car.gd")
var data = PackedByteArray()
var source_path = ""
var choices: OptionButton
var status: Label
var info: Label
var guidance: Label
var save_button: Button
var open_dialog: FileDialog
var save_dialog: FileDialog

func label(text: String, size: int = 17) -> Label:
 var node = Label.new()
 node.text = text
 node.add_theme_font_size_override("font_size",size)
 node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 return node

func _ready():
 get_window().min_size = Vector2i(760,660)
 var margin = MarginContainer.new()
 margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 for side in ["left","top","right","bottom"]: margin.add_theme_constant_override("margin_"+side,28)
 add_child(margin)
 var column = VBoxContainer.new()
 column.add_theme_constant_override("separation",12)
 margin.add_child(column)
 var brand = label("RETROPOWERHOUSE.COM   /   5200 UTILITIES",14)
 brand.modulate = Color("79c9eb")
 column.add_child(brand)
 column.add_child(label("5200 CAR Helper",32))
 column.add_child(label("Add a cartridge header to a raw Atari 5200 ROM.\nYour original file stays unchanged."))
 var open_button = Button.new()
 open_button.text = "1   Choose ROM file…"
 open_button.custom_minimum_size.y = 46
 open_button.pressed.connect(func(): open_dialog.popup_centered_ratio(0.8))
 column.add_child(open_button)
 info = label("Choose a .bin, .rom or .a52 file, or drop it into this window.")
 column.add_child(info)
 column.add_child(label("2   Select the cartridge layout",19))
 choices = OptionButton.new()
 choices.custom_minimum_size.y = 42
 choices.add_item("Choose a ROM first")
 choices.disabled = true
 choices.item_selected.connect(_selection_changed)
 column.add_child(choices)
 guidance = label("File size narrows the choices. It cannot identify every cartridge layout.",16)
 guidance.custom_minimum_size.y = 68
 column.add_child(guidance)
 save_button = Button.new()
 save_button.text = "3   Save .CAR file…"
 save_button.custom_minimum_size.y = 46
 save_button.disabled = true
 save_button.pressed.connect(_choose_output)
 column.add_child(save_button)
 status = label("Ready. All conversion happens on your computer.",16)
 status.custom_minimum_size.y = 54
 column.add_child(status)
 var footer = label("A header describes the cartridge; your firmware must support that type.\n© 2026 Robert Dupuy  •  Version 1.0",14)
 footer.modulate = Color("b3bfce")
 column.add_child(footer)
 open_dialog = FileDialog.new()
 open_dialog.access = FileDialog.ACCESS_FILESYSTEM
 open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
 open_dialog.filters = PackedStringArray(["*.bin,*.rom,*.a52,*.BIN,*.ROM,*.A52 ; Raw Atari 5200 ROMs"])
 open_dialog.use_native_dialog = true
 open_dialog.file_selected.connect(_load_rom)
 add_child(open_dialog)
 save_dialog = FileDialog.new()
 save_dialog.access = FileDialog.ACCESS_FILESYSTEM
 save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
 save_dialog.filters = PackedStringArray(["*.car ; Atari cartridge image"])
 save_dialog.use_native_dialog = true
 save_dialog.file_selected.connect(_save_rom)
 add_child(save_dialog)
 get_window().files_dropped.connect(func(files):
  if files.size()==1: _load_rom(files[0])
  else: _message("Please drop one ROM at a time.",true))

func _message(text: String, bad: bool = false):
 status.text = text
 status.modulate = Color("ffb1a5") if bad else Color("97e0bc")

func _load_rom(path: String):
 data = PackedByteArray()
 source_path = ""
 save_button.disabled = true
 choices.clear()
 choices.add_item("Choose a valid ROM first",0)
 choices.disabled = true
 info.text = path.get_file()
 guidance.text = "File size narrows the choices. It cannot identify every cartridge layout."
 if not path.get_extension().to_lower() in ["bin","rom","a52","car"]:
  _message("Choose a raw .bin, .rom or .a52 file. Extract ZIP archives first.",true)
  return
 var file = FileAccess.open(path,FileAccess.READ)
 if file == null:
  _message("Could not open this file. Check its permissions.",true)
  return
 if file.get_length() > 524304:
  _message("This file is larger than the supported 512 KB ROM layouts.",true)
  return
 var loaded = file.get_buffer(file.get_length())
 file.close()
 var error = Car.error_for(loaded)
 if not error.is_empty():
  _message(error,true)
  return
 data = loaded
 source_path = path
 info.text = "%s   •   %s bytes (%s KB)" % [path.get_file(),data.size(),data.size()/1024]
 choices.clear()
 var options = Car.candidates(data.size())
 if options.size()>1: choices.add_item("Select the correct layout…",0)
 for option in options:
  choices.add_item("%s   (CAR type %s)" % [option.name,option.id],option.id)
 choices.disabled = false
 choices.select(0)
 _selection_changed(0)

func _selection_changed(_index: int):
 save_button.disabled = data.is_empty() or choices.get_selected_id() == 0
 if data.size()==16384:
  guidance.text = "16 KB has two layouts. Choose one-chip or two-chip using the ROM's documentation. If unknown, save and test each as a separately named CAR file. Size alone cannot decide."
 elif data.size()==40960:
  guidance.text = "40 KB Bounty Bob dumps have two byte layouts. Select the layout documented for your dump. Alternate layout (type 159) also requires firmware support."
 else:
  guidance.text = "This is the standard 5200 layout listed for this size. Confirm it matches your ROM; unusual or custom cartridge hardware may need another format or firmware support."
 _message("Choose a layout to continue." if save_button.disabled else "Ready to create a CAR file. The ROM bytes will be preserved.")

func _choose_output():
 var suffix = ""
 if Car.candidates(data.size()).size()>1:
  suffix = "-type%s" % choices.get_selected_id()
 save_dialog.current_dir = source_path.get_base_dir()
 save_dialog.current_file = source_path.get_file().get_basename() + suffix + ".car"
 save_dialog.popup_centered_ratio(0.8)

func _save_rom(path: String):
 if path.get_extension().to_lower() != "car": path += ".car"
 if path.to_lower() == source_path.to_lower() or FileAccess.file_exists(path):
  _message("That file already exists. Choose a new filename; existing files are never overwritten.",true)
  return
 var result = Car.encode(data,choices.get_selected_id())
 if result.is_empty():
  _message("Conversion refused: select a valid cartridge layout.",true)
  return
 var file = FileAccess.open(path,FileAccess.WRITE)
 if file == null:
  _message("Could not save here. Choose a writable folder.",true)
  return
 file.store_buffer(result)
 file.flush()
 var error = file.get_error()
 file.close()
 if error != OK:
  _message("Write failed. The output may be incomplete; try another location.",true)
  return
 var check = FileAccess.get_file_as_bytes(path)
 if check != result:
  _message("The saved file did not verify. Do not use it; try another location.",true)
  return
 _message("Saved %s — %s bytes. Copy the CAR file to your cartridge." % [path.get_file(),result.size()])
