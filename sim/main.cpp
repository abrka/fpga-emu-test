#include <iostream>
#include <curses.h>
#include <Vhex_to_seven_seg.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <cassert>
#include <optional>
#include <cstdint>
#include <bitset>
#include <curses.h>
#include <array>
#include <vector>
#include "misc.h"
#include "misc_ncurses.h"
#include "misc_fpga.h"
#include "misc_fpga_emu.h"

int main(int argc, char const *argv[])
{

	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VerilatedVcdC tfp{};
	Vhex_to_seven_seg tb{};
	tb.trace(&tfp, 99);
	tfp.open("test.vcd");
	int ticks{};
	// test_square_wave_gen(tb, tfp);

	fpga_button_t button = fpga_button_create_default<std::string>();
	button.x = 40;
	std::vector<fpga_seven_seg_t<char>> seven_segs{2,fpga_seven_seg_create_default<char>()};
	seven_segs[1].y = 0;
	seven_segs[1].x = 20;

	MEVENT ncurses_event{};
	bool ncurses_is_mouse_button_pressed{};
	ncurses_init();
	tick_module_comb(ticks, tb, tfp);

	while (true)
	{

		button.pressed = fpga_button_is_pressed(button, ncurses_event.x, ncurses_event.y, ncurses_is_mouse_button_pressed);
		if (button.pressed)
		{
			tb.i_data = tb.i_data < 0xF ? tb.i_data + 1 : 0;
			tick_module_comb(ticks, tb, tfp);
		}
		seven_segs[0].seven_seg_info = tb_o_data_to_ncurses_seven_seg_info(tb.o_data);


		fpga_button_display(button);
		for (auto &seven_seg : seven_segs)
		{
			fpga_seven_seg_display(seven_seg);
		}
		
		int ch = getch();
		if (ch == KEY_MOUSE)
		{
			if (getmouse(&ncurses_event) == OK)
				ncurses_is_mouse_button_pressed = ncurses_event.bstate == BUTTON1_PRESSED || ncurses_event.bstate == BUTTON1_CLICKED;
		}
		else
		{
			ncurses_is_mouse_button_pressed = false;
		}

		if (ch == 'q')
		{
			ncurses_exit();
			return 0;
		}
	}

	assert(0);
}
