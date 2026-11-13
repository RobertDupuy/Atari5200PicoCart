extends SceneTree
var checks=0
var failed=false
func verify(value: bool, reason: String):
 checks+=1
 if not value:
  printerr('FAIL: '+reason)
  failed=true
func _initialize(): call_deferred('run')
func run():
 var app=load('res://main.tscn').instantiate()
 root.add_child(app)
 await process_frame
 var raw=PackedByteArray()
 raw.resize(16384)
 for i in raw.size(): raw[i]=(i+19)%256
 var input='user://ui-test.a52'
 var output='user://ui-test.car'
 var file=FileAccess.open(input,FileAccess.WRITE)
 file.store_buffer(raw)
 file.close()
 DirAccess.remove_absolute(output)
 app._load_rom(input)
 verify(app.save_button.disabled,'16KB requires explicit choice')
 verify(app.choices.item_count==3,'two mappings and placeholder')
 app.choices.select(1)
 app._selection_changed(1)
 verify(not app.save_button.disabled,'mapping enables save')
 app._save_rom(output)
 verify(FileAccess.get_file_as_bytes(output).slice(16)==raw,'saved payload')
 verify(FileAccess.get_file_as_bytes(input)==raw,'original preserved')
 app.choices.select(2)
 app._selection_changed(2)
 app._save_rom(output)
 verify(app.status.text.contains('already exists'),'overwrite refused')
 verify(FileAccess.get_file_as_bytes(output)[7]==6,'old output retained')
 app._load_rom(output)
 verify(app.save_button.disabled,'headered file blocks save')
 app._load_rom('user://absent.bin')
 verify(app.save_button.disabled,'missing file blocks stale conversion')
 app._load_rom(input)
 var margin=app.get_child(0)
 verify(margin.get_combined_minimum_size().y<=660,'UI fits default height')
 for path in [input,output]: DirAccess.remove_absolute(path)
 print('PASS: ',checks,' UI and file integration checks. Minimum UI size: ',margin.get_combined_minimum_size())
 quit(1 if failed else 0)
