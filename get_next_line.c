/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: yuhayrap <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/20 13:18:01 by yuhayrap          #+#    #+#             */
/*   Updated: 2024/02/14 16:25:28 by yuhayrap         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

static char	*get_left_str(int fd, char *left_str)
{
	char	*buffer;
	int		readed_char;

	buffer = (char *)malloc(sizeof(char) * (BUFFER_SIZE + 1));
	if (buffer == NULL)
		return (NULL);
	readed_char = 1;
	while (!ft_strchr(left_str, 10) && readed_char != 0)
	{
		readed_char = read(fd, buffer, BUFFER_SIZE);
		if (readed_char < 0)
		{
			free(buffer);
			return (NULL);
		}
		buffer[readed_char] = '\0';
		left_str = ft_strjoin(left_str, buffer);
	}
	free(buffer);
	return (left_str);
}

char	*get_next_line(int fd)
{
	static char	*left_str;
	char		*line;

	if (fd < 0 || BUFFER_SIZE <= 0 || read(fd, 0, 0) < 0)
	{
		free(left_str);
		left_str = NULL;
		return (0);
	}
	left_str = get_left_str(fd, left_str);
	if (!left_str)
		return (NULL);
	line = get_line(left_str);
	left_str = get_new_left_str(left_str);
	return (line);
}

// int main(void)
// {
// 	int	fileDesk;

// 	fileDesk = open("test.txt", O_RDONLY);
// 	printf("%s", get_next_line(fileDesk));
// }
