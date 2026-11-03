#include "vga.h"
#include "string.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY 0xB8000

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t *const terminal_buffer = (uint16_t *)VGA_MEMORY;

static uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
	return fg | bg << 4;
}

static uint16_t vga_entry(unsigned char uc, uint8_t color)
{
	return (uint16_t)uc | (uint16_t)color << 8;
}

static void terminal_newline(void)
{
	terminal_column = 0;
	if (++terminal_row == VGA_HEIGHT)
		terminal_row = 0;
}

void terminal_initialize(void)
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	for (size_t i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
		terminal_buffer[i] = vga_entry(' ', terminal_color);
}

void terminal_setcolor(enum vga_color fg, enum vga_color bg)
{
	terminal_color = vga_entry_color(fg, bg);
}

void terminal_putchar(char c)
{
	if (c == '\n')
	{
		terminal_newline();
		return;
	}
	terminal_buffer[terminal_row * VGA_WIDTH + terminal_column] = vga_entry(c, terminal_color);
	if (++terminal_column == VGA_WIDTH)
		terminal_newline();
}

void terminal_write(const char *data, size_t size)
{
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

void terminal_writestring(const char *data)
{
	terminal_write(data, strlen(data));
}
