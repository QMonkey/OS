BUILD_PATH = build

IMGS = $(BUILD_PATH)/boot.img
OBJS = $(BUILD_PATH)/boot.bin

all: $(IMGS)

$(BUILD_PATH)/boot.img: $(BUILD_PATH)/boot.bin
	dd if=$< of=$@ bs=512 count=1

$(BUILD_PATH)/boot.bin: boot/boot.asm
	nasm $< -o $@ -I include/

run:
	qemu-system-x86_64 build/boot.img

clean:
	-rm -rf $(IMGS) $(OBJS)
