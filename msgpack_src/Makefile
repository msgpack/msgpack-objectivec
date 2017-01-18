src := $(wildcard *.c)
objs := $(src:.c=.o)

library:$(objs)
	libtool -static -o libmsgpack_c_temp.a $(objs)

%.o:%.c
	clang -c -O2 $<

clean:;rm -rf *.o *.a
