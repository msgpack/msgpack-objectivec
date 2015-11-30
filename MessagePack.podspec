Pod::Spec.new do |spec|
  spec.name = "MessagePack"
  spec.version = "1.0.0"
  spec.license = "Apache License, Version 2.0"
  spec.summary = "Extremely efficient object serialization library. It's like JSON, but very fast and small."
  spec.description = "This is a wrapper for the C MessagePack parser, building the bridge to\nObjective-C. In a similar way to the JSON framework, this parses MessagePack\ninto NSDictionaries, NSArrays, NSNumbers, NSStrings, and NSNulls. This contains\na small patch to the C library so that it doesn't segfault with a byte alignment\nerror when running on the iPhone in armv7 mode. Please note that the parser has\nbeen extensively tested, however the packer has not been. Please get in touch if\nit has issues.\n"
  spec.homepage = "https://github.com/loderunner/msgpack-objectivec"
  spec.authors = { "Chris Hulbert" => "chris.hulbert@gmail.com",
                   "Charles Francoise" => "charles.francoise@gmail.com" }
  spec.source = { :git => "https://github.com/loderunner/msgpack-objectivec.git",
                  :tag => "1.0.0" }
  spec.source_files = "*.{h,m}", "msgpack_src/*.{c,h}", "msgpack_src/msgpack/*.h"
  spec.requires_arc = true
end