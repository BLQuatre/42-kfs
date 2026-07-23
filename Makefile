NAME = kfs

AS = i686-elf-as
CC = i686-elf-gcc

# Directories
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
ISO_DIR = isodir

# Flags
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I$(INC_DIR) \
		 -fno-builtin -fno-stack-protector -nostdlib -nodefaultlibs
LDFLAGS = -T linker.ld -ffreestanding -O2 -nostdlib -nodefaultlibs

# Source files
C_FILES = kernel

S_FILES = boot

H_FILES = kernel

# SRCS = $(addprefix $(SRC_DIR)/, $(addsuffix .c, $(C_FILES))) \ // Don't think this is needed
# 	  $(addprefix $(SRC_DIR)/, $(addsuffix .s, $(S_FILES)))

HEADERS = $(addprefix $(INC_DIR)/, $(addsuffix .h, $(H_FILES)))

OBJS = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(C_FILES))) \
	  $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(S_FILES)))


all: $(BIN_DIR)/$(NAME).iso

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS) | $(OBJ_DIR)
	$(CC) -c $< -o $@ $(CFLAGS)

$(BIN_DIR)/$(NAME): $(OBJS) linker.ld | $(BIN_DIR)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) -lgcc
	grub-file --is-x86-multiboot $@

$(BIN_DIR)/$(NAME).iso: $(BIN_DIR)/$(NAME) grub.cfg
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(BIN_DIR)/$(NAME) $(ISO_DIR)/boot/$(NAME)
	cp grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $@ $(ISO_DIR)

run: $(BIN_DIR)/$(NAME).iso
	qemu-system-i386 -cdrom $(BIN_DIR)/$(NAME).iso

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(ISO_DIR)

.PHONY: all run clean
