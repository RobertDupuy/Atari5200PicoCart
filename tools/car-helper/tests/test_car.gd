extends SceneTree
const Car=preload("res://car.gd")
var checks=0
var failed=false
func verify(value: bool, reason: String):
 checks+=1
 if not value:
  printerr("FAIL: "+reason)
  failed=true
func _initialize():
 for t in Car.TYPES:
  var raw=PackedByteArray()
  raw.resize(t.kb*1024)
  for i in raw.size(): raw[i]=(i*31+7)%256
  var result=Car.encode(raw,t.id)
  verify(result.size()==raw.size()+16,"size")
  verify(result.slice(0,4).get_string_from_ascii()=="CART","magic")
  verify(result.slice(16)==raw,"payload preserved")
  var stream=StreamPeerBuffer.new()
  stream.data_array=result
  stream.big_endian=true
  stream.seek(4)
  verify(stream.get_u32()==t.id,"big endian type")
  verify(stream.get_u32()==raw.size()/256*32640,"independent checksum")
  verify(stream.get_u32()==0,"reserved zero")
  verify(Car.encode(result,t.id).is_empty(),"double header refused")
 var small=PackedByteArray()
 small.resize(4096)
 small.fill(255)
 verify(Car.encode(small,20).slice(8,12)==PackedByteArray([0,15,240,0]),"known checksum bytes")
 verify(Car.encode(small,4).is_empty(),"wrong size refused")
 verify(Car.encode(small,999).is_empty(),"unknown type refused")
 verify(Car.encode(PackedByteArray(),20).is_empty(),"empty refused")
 small.resize(10240)
 verify(not Car.error_for(small).is_empty(),"10KB refused")
 verify(Car.candidates(16384).size()==2,"16KB ambiguous")
 verify(Car.candidates(40960).size()==2,"40KB ambiguous")
 print("PASS: ",checks," checks across all 11 layouts")
 quit(1 if failed else 0)
