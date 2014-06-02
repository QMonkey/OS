IMG = floppy.img
OBJ = protect_mode.com

all: $(IMG)

floppy.img: protect_mode.com
	sudo mount -o loop $@ /mnt/floppy
	sudo cp $(OBJ) /mnt/floppy
	sudo umount /mnt/floppy

protect_mode.com: protect_mode.asm
	nasm $< -o $@ -I ../include/

run:
	bochs -f bochsrc

clean:
	-rm -rf $(OBJ)
