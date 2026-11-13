extends RefCounted
const TYPES = [
 {"id":20,"kb":4,"name":"Standard 4 KB"},
 {"id":19,"kb":8,"name":"Standard 8 KB"},
 {"id":6,"kb":16,"name":"Two-chip 16 KB"},
 {"id":16,"kb":16,"name":"One-chip 16 KB"},
 {"id":4,"kb":32,"name":"Standard 32 KB"},
 {"id":7,"kb":40,"name":"Bounty Bob 40 KB — standard layout"},
 {"id":159,"kb":40,"name":"Bounty Bob 40 KB — alternate layout"},
 {"id":71,"kb":64,"name":"Super Cart 64 KB"},
 {"id":72,"kb":128,"name":"Super Cart 128 KB"},
 {"id":73,"kb":256,"name":"Super Cart 256 KB"},
 {"id":74,"kb":512,"name":"Super Cart 512 KB"}
]
static func candidates(size: int) -> Array:
 return TYPES.filter(func(t): return t.kb * 1024 == size)
static func checksum(data: PackedByteArray) -> int:
 var sum: int = 0
 for b in data:
  sum = (sum + b) & 0xffffffff
 return sum
static func has_header(data: PackedByteArray) -> bool:
 return data.size() >= 4 and data.slice(0,4).get_string_from_ascii() == "CART"
static func error_for(data: PackedByteArray) -> String:
 if has_header(data): return "This file already starts with a CART header. No second header will be added."
 if candidates(data.size()).is_empty():
  return "No supported Atari 5200 cartridge layout matches %s bytes. The helper will not pad or trim a ROM. Obtain a complete raw dump and its cartridge type." % data.size()
 return ""
static func encode(data: PackedByteArray, type_id: int) -> PackedByteArray:
 if not error_for(data).is_empty(): return PackedByteArray()
 if not candidates(data.size()).any(func(t): return t.id == type_id): return PackedByteArray()
 var stream = StreamPeerBuffer.new()
 stream.big_endian = true
 stream.put_data("CART".to_ascii_buffer())
 stream.put_u32(type_id)
 stream.put_u32(checksum(data))
 stream.put_u32(0)
 stream.put_data(data)
 return stream.data_array
