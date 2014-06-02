IMG = protect_mode.img
OBJ = protect_mode.com

all: $(IMG)

protect_mode.img: protect_mode.com
	cp test.img $@
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

protect_mode.com: protect_mode.asm
	nasm $< -o $@ -I ../include/

run:
	qemu-system-x86_64 protect_mode.img

clean:
	-rm -rf $(IMG) $(OBJ)
