# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: efouille <efouille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/07/18 14:36:22 by efouille          #+#    #+#              #
#    Updated: 2018/11/16 21:46:58 by afrangio         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CC=clang

NAME=libft.a

SOURCE=$(wildcard *.c)

HEADER=libft.h

OBJ=${SOURCE:.c=.o}

all: $(NAME)

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)
	ranlib $(NAME)

%.o: %.c $(HEADER)
	$(CC) -c -Wall -Werror -Wextra -o $@ $<

clean:
	/bin/rm -f $(OBJ)

fclean: clean
	/bin/rm -f $(NAME)

re: fclean all
