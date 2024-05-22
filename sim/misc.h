#pragma once 

const std::string term_color_red("\033[0;31m");
const std::string term_color_green("\033[1;32m");
const std::string term_color_yellow("\033[1;33m");
const std::string term_color_cyan("\033[0;36m");
const std::string term_color_magenta("\033[0;35m");
const std::string term_color_reset("\033[0m");
const std::string term_color_white("\x1B[37m");
const std::string term_color_blue("\x1B[34m");

template < typename StringType = std::string, typename StringStreamType = std::istringstream>
size_t string_get_max_line_length(const StringType &str)
{
	StringStreamType istream{str};
	StringType line{};
	size_t max_line_len{};
	while (std::getline(istream, line))
	{
		if (line.length() > max_line_len)
		{
			max_line_len = line.length();
		}
	}
	return max_line_len;
}
template <typename StringType = std::string, typename StringStreamType = std::istringstream>
int string_get_vertical_length(const StringType &str)
{
	StringStreamType istream{str};
	StringType line{};
	int i{};
	while (std::getline(istream, line))
	{
		i++;
	}
	return i;
}

bool point_in_box_collision(int point_x, int point_y, int box_x, int box_y, int box_w, int box_h)
{
	return point_x > box_x && point_x < box_x + box_w && point_y > box_y && point_y < box_y + box_h;
}

