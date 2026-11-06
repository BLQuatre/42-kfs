NAME = kfs

# Directories
SRC_DIR = src
INC_DIR = include
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
ISO_DIR = $(BUILD_DIR)/isodir
ARCH_DIR = arch/i386

KERNEL   = $(BUILD_DIR)/$(NAME).bin
ISO      = $(NAME).iso
LINKER   = $(ARCH_DIR)/linker.ld
GRUB_CFG = $(ARCH_DIR)/grub.cfg

C_FILES  = kernel lib/string drivers/vga
S_FILES  = boot

OBJS     = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(S_FILES) $(C_FILES)))
DEPS     = $(OBJS:.o=.d)

ifeq ($(shell uname -s),Darwin)
TOOLPREFIX = i686-elf-
endif

CC       = clang
LD       = $(TOOLPREFIX)ld
TARGET   = --target=i686-elf

CFLAGS   = $(TARGET) -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Werror \
           -fno-builtin -fno-exceptions -fno-stack-protector -fno-rtti \
           -nostdlib -nodefaultlibs -nostdinc \
           -mno-mmx -mno-sse -mno-sse2 -mno-80387 \
           -I$(INC_DIR) -MMD -MP
ASFLAGS  = $(TARGET)
LDFLAGS  = -m elf_i386 -T $(LINKER) --build-id=none
GRUBFLAGS = --install-modules="multiboot normal" --fonts="" --locales="" --themes=""

all: $(NAME)

$(NAME): $(ISO)

$(OBJ_DIR)/%.o: $(ARCH_DIR)/%.s
	mkdir -p $(@D)
	$(CC) $(ASFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJS) $(LINKER)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(TOOLPREFIX)grub-file --is-x86-multiboot $@

$(ISO): $(KERNEL) $(GRUB_CFG)
	rm -rf $(ISO_DIR)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL) $(ISO_DIR)/boot/$(NAME).bin
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/grub.cfg
	$(TOOLPREFIX)grub-mkrescue $(GRUBFLAGS) -o $@ $(ISO_DIR)

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO) -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR)

fclean: clean
	rm -f $(ISO)

re: fclean all

-include $(DEPS)

.PHONY: all $(NAME) run clean fclean re
