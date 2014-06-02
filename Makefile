BUILD_PATH = build

IMGS = $(BUILD_PATH)/boot.img
OBJS = $(BUILD_PATH)/boot.bin $(BUILD_PATH)/loader.bin $(BUILD_PATH)/kernel.bin

all: $(IMGS)

$(BUILD_PATH)/boot.img: $(BUILD_PATH)/boot.bin $(BUILD_PATH)/loader.bin $(BUILD_PATH)/kernel.bin
	cat $(BUILD_PATH)/boot.bin $(BUILD_PATH)/loader.bin $(BUILD_PATH)/kernel.bin > $@

$(BUILD_PATH)/boot.bin: boot/boot.asm
	nasm $< -o $@ -I include/

$(BUILD_PATH)/loader.bin: boot/loader.asm
	nasm $< -o $@ -I include/

$(BUILD_PATH)/kernel.bin: kernel/kernel.asm
	nasm $< -o $@ -I include/

run:
	qemu-system-x86_64 build/boot.img

clean:
	-rm -rf $(IMGS) $(OBJS)
