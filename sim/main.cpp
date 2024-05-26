#include <iostream>
#include <curses.h>
#include <Vtop.h>
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
	Vtop tb{};
	tb.trace(&tfp, 99);
	tfp.open("test.vcd");
	int ticks{};
	// test_square_wave_gen(tb, tfp);

	std::vector<fpga_button_t<std::string>> buttons{4, fpga_button_create_default<std::string>()};
	for (size_t i = 0; i < buttons.size(); i++)
	{
		buttons[i].x = (buttons.size() - 1 - i) * 10 + 100;
		buttons[i].y = 10;
	}

	std::vector<fpga_button_t<std::string>> slide_switches{8, fpga_button_create_slide_switch<std::string>()};

	for (size_t i = 0; i < slide_switches.size(); i++)
	{
		slide_switches[i].x = (slide_switches.size() - 1 - i) * 10;
		slide_switches[i].y = 12;
	}

	std::vector<fpga_seven_seg_t<char>> seven_segs{4, fpga_seven_seg_create_default<char>()};
	for (size_t i = 0; i < seven_segs.size(); i++)
	{
		seven_segs[i].x = (seven_segs.size() - 1 - i) * 20;
		seven_segs[i].y = 0;
	}

	std::vector<fpga_led_t<std::string>> leds{8, fpga_led_create_default<std::string>()};
	for (size_t i = 0; i < leds.size(); i++)
	{
		leds[i].x = (leds.size() - 1 - i) * 10 + 80;
		leds[i].y = 2;
	}

	MEVENT ncurses_event{};
	bool ncurses_is_mouse_button_pressed{};
	ncurses_init();

	while (true)
	{

		for (auto &button : buttons)
		{
			button.state = fpga_button_get_state(button, ncurses_event.x, ncurses_event.y, ncurses_is_mouse_button_pressed);
		}
		for (auto &slide_switch : slide_switches)
		{
			slide_switch.state = fpga_slide_switch_get_state(slide_switch, ncurses_event.x, ncurses_event.y, ncurses_is_mouse_button_pressed);
		}


		for (size_t i = 0; i < seven_segs.size(); i++)
		{
			std::bitset<4> tb_sseg_enables {tb.o_sseg_enables};
			bool is_this_sseg_enabled = tb_sseg_enables[i];
			seven_segs[i].seven_seg_info = tb_o_data_to_ncurses_seven_seg_info( is_this_sseg_enabled ? tb.o_sseg : 0 );
		}
		
		

		for (size_t i = 0; i < leds.size(); i++)
		{
			leds[i].state = (std::bitset<8>(tb.o_leds))[i];
		}

		tb.i_btn = buttons[0].state;

		std::bitset<8> tb_i_slide_switch_data{};
		for (size_t i = 0; i < slide_switches.size(); i++)
		{
			tb_i_slide_switch_data[i] = slide_switches[i].state;
		}
		tb.i_slide_switches = tb_i_slide_switch_data.to_ulong();

		tick_module(ticks, tb, tfp);

		for (auto &button : buttons)
		{
			fpga_button_display(button);
		}
		for (auto &slide_switch : slide_switches)
		{
			fpga_button_display(slide_switch);
		}

		for (auto &seven_seg : seven_segs)
		{
			fpga_seven_seg_display(seven_seg);
		}
		for (auto &led : leds)
		{
			fpga_led_display(led);
		}

		int ch = getch();
		if (ch == KEY_MOUSE)
		{
			if (getmouse(&ncurses_event) == OK)
			{
				ncurses_is_mouse_button_pressed = ncurses_event.bstate == BUTTON1_PRESSED || ncurses_event.bstate == BUTTON1_CLICKED;
			}
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
