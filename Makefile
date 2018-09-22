all:
	nasm -g -O0 -Wall -f elf64 ass1.asm -o ass1.o
	ld ass1.o -o ass1.out

clean:
	$(RM) ass1.o ass1.out
