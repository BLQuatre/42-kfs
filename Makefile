NAME = kfs

# Directories
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
ISO_DIR = isodir

KERNEL   = $(BIN_DIR)/$(NAME).bin
ISO      = $(BIN_DIR)/$(NAME).iso

C_FILES  = kernel
S_FILES  = boot

OBJS     = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(S_FILES) $(C_FILES)))
DEPS     = $(OBJS:.o=.d)

CC       = clang
LD       = ld.lld
TARGET   = --target=i686-elf

CFLAGS   = $(TARGET) -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Werror \
           -fno-builtin -fno-exceptions -fno-stack-protector -fno-rtti \
           -nostdlib -nodefaultlibs \
           -mno-mmx -mno-sse -mno-sse2 -mno-80387 \
           -I$(INC_DIR) -MMD -MP
ASFLAGS  = $(TARGET)
LDFLAGS  = -m elf_i386 -T linker.ld --build-id=none
GRUBFLAGS = --install-modules="multiboot normal" --fonts="" --locales="" --themes=""

all: $(NAME)

$(NAME): $(ISO)

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJS) linker.ld | $(BIN_DIR)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	grub-file --is-x86-multiboot $@

$(ISO): $(KERNEL) grub.cfg
	rm -rf $(ISO_DIR)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL) $(ISO_DIR)/boot/$(NAME).bin
	cp grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue $(GRUBFLAGS) -o $@ $(ISO_DIR)

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO) -no-reboot -no-shutdown

clean:
	rm -rf $(OBJ_DIR) $(ISO_DIR)

fclean: clean
	rm -rf $(BIN_DIR)

re: fclean all

-include $(DEPS)

.PHONY: all $(NAME) run clean fclean re
