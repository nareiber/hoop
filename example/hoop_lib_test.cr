require "./../src/hoop"

include Hoop

@[Link(ldflags: "#{__DIR__}/../HoopLib/HoopLib/hoop_lib.a")]
lib LibHoop
  fun setup : Int32
  fun dump_objc_methods(LibObjC::ObjcClass*) : Void
end

LibHoop.setup

class HoopLib < NSObject
  register_class
  method "init", nil, "instancetype", "initialize"
  method "test", nil, "void", "test"
  method "blockTest:", ["id"], "void", "block_test"
  method "newBlockTest:andOtherBlock:", ["id", "id"], "NSString", "new_block_test"
  method "setTestText:", ["NSString"], "void", "set_test_text"
  method "testText", nil, "NSString", "test_text"
end

class HoopView < NSView
  register_class
  method "hoopClassName", nil, "NSString", "hoop_class_name"
end

LibHoop.dump_objc_methods(NSView.nsclass.obj)

hoop_lib = HoopLib.new
hoop_lib.set_test_text "test text"
hoop_lib.test
hoop_lib.block_test ->(x : UInt8*, y : UInt8*) {
  x = HoopLib.new(x)
  y = NSString.new(y)
  ns_log y
  ns_log x.test_text
  return 1
}

block_test_value = hoop_lib.new_block_test(->(hoop_lib_self : UInt8*, hoop_view : UInt8*) {
  hoop_lib_self = HoopLib.new(hoop_lib_self)
  hoop_view = HoopView.new(hoop_view)
  ns_log "hoop lib test text value: #{hoop_lib_self.test_text}"
  ns_log "hoop view class name: #{hoop_view.hoop_class_name}"
  return 1
}, ->(a : UInt8*, b : UInt8*) {
  a = NSString.new(a)
  b = NSString.new(b)
  ns_log "a value: #{a} - b value: #{b}"
  return 1
})

ns_log "block test value: #{block_test_value}"
