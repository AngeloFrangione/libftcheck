# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: efouille <efouille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/07/18 14:36:22 by efouille          #+#    #+#              #
#    Updated: 2018/05/17 15:26:36 by efouille         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CC=clang

NAME=libft.a

SOURCE=ft_isalpha.c ft_isdigit.c ft_isalnum.c ft_isascii.c ft_isprint.c ft_toupper.c ft_tolower.c ft_strlen.c ft_strdup.c ft_strcpy.c ft_strncpy.c ft_strcat.c ft_strncat.c ft_strlcat.c ft_strchr.c ft_strrchr.c ft_strstr.c ft_strnstr.c ft_strcmp.c ft_strncmp.c ft_memset.c ft_bzero.c ft_memcpy.c ft_memccpy.c ft_memmove.c ft_memchr.c ft_memcmp.c ft_atoi.c

SOURCE+=ft_putchar_fd.c ft_putchar.c ft_putstr_fd.c ft_putstr.c ft_putendl_fd.c ft_putendl.c ft_strjoin.c ft_memalloc.c ft_memdel.c ft_strnew.c ft_strdel.c ft_strclr.c ft_striter.c ft_striteri.c ft_strmap.c ft_strmapi.c ft_strequ.c ft_strnequ.c ft_strsub.c ft_strtrim.c ft_itoa.c ft_putnbr_fd.c ft_putnbr.c ft_strsplit.c

HEADER=libft.h

OBJ=${SOURCE:.c=.o}

all: $(NAME)

$(NAME): $(OBJ)
	@ar rcs $(NAME) $(OBJ)
	@ranlib $(NAME)

%.o: %.c $(HEADER)
	@$(CC) -g -c -Wall -Werror -Wextra -o $@ $<

clean:
	@/bin/rm -f $(OBJ)

fclean: clean
	@/bin/rm -f $(NAME)

re: fclean all
