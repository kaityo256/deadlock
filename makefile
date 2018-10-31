all: a.out b.out

CC=mpic++
CPPFLAGS=

-include makefile.opt

a.out: test.cpp
	$(CC) $< -o $@ 

b.out: test2.cpp
	$(CC) $< -o $@ 

clean:
	rm -f a.out b.out

