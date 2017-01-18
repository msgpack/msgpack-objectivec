lib_name := libmsgpack-objc.dylib
lib_flags := -shared -fPIC

objc_files := $(wildcard *.m)
objc_objs := $(objc_files:.m=.o)

objc_library:$(objc_objs)
	make -C msgpack_src library
	clang -L./msgpack_src -lmsgpack_c_temp \
	-framework Foundation \
	${lib_flags} -o ${lib_name} $(objc_objs)

%.o:%.m
	clang -c ${flags} $<

clean:
	@rm -rf *.o ${lib_name}
	make -C msgpack_src clean
