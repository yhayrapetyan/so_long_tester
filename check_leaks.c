#include "get_next_line.h"

int	substring_len(char *search_in, char *to_find)
{
	int	i;

	i = 0;
	while (to_find[i] != '\0')
	{
		if (search_in[i] != to_find[i])
			return (0);
		i++;
	}
	return (i);
}

int ft_strstr(char *str, char *to_find)
{
	int	i;

	i = 0;
	if (to_find[i] == '\0')
		return (1);
	while (str[i] != '\0')
	{
		if (str[i] == to_find[0])
		{
			if (substring_len(str + i, to_find))
				return 1;
		}
		i++;
	}
	return (0);
}

int main(int ac, char **av)
{
    int     fd;
    char    *result;

    fd = open(av[1], O_RDONLY);
    if (fd < 0)
        exit(1);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    result = get_next_line(fd);
    if (!ft_strstr(result, "All heap blocks were freed -- no leaks are possible"))
        exit(1);
    return (0);
}