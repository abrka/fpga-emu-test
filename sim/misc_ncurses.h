#pragma once

#include <curses.h>
#include <string>
#include <sstream>
#include <bitset>


void ncurses_init(){
	initscr();
	raw();								// disable line buffering
	curs_set(0);					// hide cursor
	use_default_colors(); // enable transparent black
	start_color();				// enable color
	clear();							// clear screen
	noecho();							// disable echo
	cbreak();							// disable line buffering
	keypad(stdscr, true); // enable function keys

	// scrollok(stdscr, TRUE);
	// idlok(stdscr, TRUE);
	//
	mousemask(ALL_MOUSE_EVENTS, nullptr);
  timeout(0);
}

void ncurses_exit(){
	curs_set(1);
	clear();
	refresh();
	endwin();
}

struct seven_seg_info_t
{
	bool a{}, b{}, c{}, d{}, e{}, f{}, g{}, dp{};
};

template <typename T>
seven_seg_info_t tb_o_data_to_ncurses_seven_seg_info(T tb_o_data)
{
	std::bitset<7> tb_o_seven_seg_info{(unsigned long long)tb_o_data};
	seven_seg_info_t seven_seg_info{
			.a = tb_o_seven_seg_info[0],
			.b = tb_o_seven_seg_info[1],
			.c = tb_o_seven_seg_info[2],
			.d = tb_o_seven_seg_info[3],
			.e = tb_o_seven_seg_info[4],
			.f = tb_o_seven_seg_info[5],
			.g = tb_o_seven_seg_info[6],
			.dp = 0};
	return seven_seg_info;
}

void ncurses_draw_seven_seg_vertical_bar(int y_initial, int x_initial, int bar_len_y, char bar_char)
{
	for (int y = y_initial; y < y_initial + bar_len_y; y++)
	{
		mvaddch(y, x_initial, bar_char);
	}
}

void ncurses_draw_seven_seg_horizontal_bar(int y_initial, int x_initial, const std::string &bar_str)
{
	mvaddstr(y_initial, x_initial, bar_str.c_str());
}

void ncurses_clear_area(int y_initial, int total_y_size, int x_initial, int total_x_size)
{
  for (int y = y_initial; y < y_initial + total_y_size; y++)
  {
    for (int x = x_initial; x < x_initial + total_x_size; x++)
    {
      mvaddch(y, x, ' ');
    }
  }
}

void ncurses_draw_seven_seg(int y_initial, int x_initial, int bar_len_y, int bar_len_x, char bar_char, seven_seg_info_t seven_seg_info)
{

	int total_y_size = bar_len_y*2+1;
	int total_x_size = bar_len_x+1;

  ncurses_clear_area(y_initial, total_y_size, x_initial, total_x_size);

  std::string bar_str = std::string(bar_len_x, bar_char);

	if (seven_seg_info.a)
		ncurses_draw_seven_seg_horizontal_bar(y_initial, x_initial, bar_str);
	if (seven_seg_info.g)
		ncurses_draw_seven_seg_horizontal_bar(y_initial + bar_len_y, x_initial, bar_str);

	if (seven_seg_info.d)
		ncurses_draw_seven_seg_horizontal_bar(y_initial + bar_len_y * 2, x_initial, bar_str);

	if (seven_seg_info.f)
		ncurses_draw_seven_seg_vertical_bar(y_initial, x_initial, bar_len_y, bar_char);
	if (seven_seg_info.b)
		ncurses_draw_seven_seg_vertical_bar(y_initial, x_initial + bar_len_x, bar_len_y, bar_char);
	if (seven_seg_info.e)
		ncurses_draw_seven_seg_vertical_bar(y_initial + bar_len_y, x_initial, bar_len_y, bar_char);
	if (seven_seg_info.c)
		ncurses_draw_seven_seg_vertical_bar(y_initial + bar_len_y, x_initial + bar_len_x, bar_len_y, bar_char);

	refresh();
}


template<typename StringType=std::string, typename StringStreamType = std::istringstream>
void ncurses_draw_ascii_art(int y_initial, int x_initial, const StringType& ascii_art){
	StringStreamType str{ascii_art};
	StringType line{};
	int i{};
	while(std::getline(str, line)){
		mvaddstr(y_initial + i, x_initial, line.c_str());
		i++;
	}
	refresh();
	
}

