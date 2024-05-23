#pragma once

#include "misc_ncurses.h"
#include "misc.h"

template <typename StringType>
struct fpga_button_t
{
	int x{};
	int y{};
	int width{};
	int height{};
	StringType pressed_ascii_art{};
	StringType unpressed_ascii_art{};
	bool state{};
};

static const std::string default_button_unpressed_str{
		R"(
_______
|  _  |
| [_] |
|_____|
)"};

static const std::string default_button_pressed_str{
		R"(
######
######
######
)"};

template <typename StringType>
fpga_button_t<StringType> fpga_button_create_default()
{
	return fpga_button_t<StringType>{
			.width = string_get_max_line_length(default_button_unpressed_str),
			.height = string_get_vertical_length(default_button_unpressed_str),
			.pressed_ascii_art = default_button_pressed_str,
			.unpressed_ascii_art = default_button_unpressed_str

	};
}

static const std::string default_slide_switch_on_str{
		R"(
_______
|__###|
)"};

static const std::string default_slide_switch_off_str{
		R"(
_______
|###__|
)"};

template <typename StringType>
fpga_button_t<StringType> fpga_button_create_slide_switch()
{
	return fpga_button_t<StringType>{
			.width = string_get_max_line_length(default_slide_switch_on_str),
			.height = string_get_vertical_length(default_slide_switch_on_str),
			.pressed_ascii_art = default_slide_switch_on_str,
			.unpressed_ascii_art = default_slide_switch_off_str

	};
}


template <typename StringType>
void fpga_button_display(const fpga_button_t<StringType> &button)
{
	if (button.state)
		ncurses_draw_ascii_art(button.y, button.x, button.pressed_ascii_art);
	else
		ncurses_draw_ascii_art(button.y, button.x, button.unpressed_ascii_art);
}

template <typename StringType>
bool fpga_button_get_state(const fpga_button_t<StringType> &button, int mouse_x, int mouse_y, int is_mouse_pressed)
{
	return is_mouse_pressed && point_in_box_collision(mouse_x, mouse_y, button.x, button.y, button.width, button.height);
}


template <typename StringType>
bool fpga_slide_switch_get_state(const fpga_button_t<StringType> &button, int mouse_x, int mouse_y, int is_mouse_pressed)
{
	if(fpga_button_get_state<StringType>(button, mouse_x, mouse_y, is_mouse_pressed)){
		return !button.state;
	}
	else return button.state;
}

template <typename CharType = char>
struct fpga_seven_seg_t
{
	int x{};
	int y{};
	int bar_len_x{};
	int bar_len_y{};
	CharType bar_char{};
	seven_seg_info_t seven_seg_info{};
};

static const char default_seven_seg_bar_char = '#';
static const int default_seven_seg_bar_len_x = 10;
static const int default_seven_seg_bar_len_y = 5;

template <typename CharType>
fpga_seven_seg_t<CharType> fpga_seven_seg_create_default()
{
	return fpga_seven_seg_t<CharType>{
			.bar_len_x = default_seven_seg_bar_len_x,
			.bar_len_y = default_seven_seg_bar_len_y,
			.bar_char = default_seven_seg_bar_char,
			.seven_seg_info = {
					.a = 1,
					.b = 1,
					.c = 1,
					.d = 1,
					.e = 1,
					.f = 1,
					.g = 1,
					.dp = 1}};
}

template <typename CharType>
void fpga_seven_seg_display(const fpga_seven_seg_t<CharType> &seven_seg)
{
	ncurses_draw_seven_seg(seven_seg.y, seven_seg.x, seven_seg.bar_len_y, seven_seg.bar_len_x, seven_seg.bar_char, seven_seg.seven_seg_info);
}

template <typename StringType>
struct fpga_led_t
{
	int x{};
	int y{};
	bool state{};
	StringType on_ascii_art{};
	StringType off_ascii_art{};
};
static const std::string default_fpga_led_off_ascii_art{
		R"(
 --
|  |
\||/
 ||
	)"};
static const std::string default_fpga_led_on_ascii_art{
		R"(
 --
|##|
\||/
 ||
	)"};

template <typename StringType>
fpga_led_t<StringType> fpga_led_create_default()
{
	return fpga_led_t<StringType>{
			.on_ascii_art = default_fpga_led_on_ascii_art,
			.off_ascii_art = default_fpga_led_off_ascii_art};
}

template <typename StringType>
void fpga_led_display(const fpga_led_t<StringType>& led){
	if(led.state == 1)
	ncurses_draw_ascii_art(led.y, led.x, led.on_ascii_art);
	else ncurses_draw_ascii_art(led.y, led.x, led.off_ascii_art);

}