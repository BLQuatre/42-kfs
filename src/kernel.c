#include "vga.h"

void kernel_main(void)
{
	terminal_initialize();

	terminal_writestring("42\n");

	terminal_writecoloredstring("This is a black text on light blue background\n", VGA_COLOR_BLACK, VGA_COLOR_LIGHT_BLUE);
	terminal_writecoloredstring("This is a red text on light gray background\n", VGA_COLOR_RED, VGA_COLOR_LIGHT_GREY);
}
