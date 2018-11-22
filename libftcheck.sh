#!/bin/sh

print_usage()
{
	printf "Usage : libftcheck.sh [options] git_repo (or path if --no_git)\n"
	printf "\n"
	printf "options : -s | --no-sa          Ignore Clang Static Analyzer tests\n"
	printf "          -d | --no-sa-down     Do not download Clang Static Analyzer\n"
	printf "          -r | --reopen-report  Do not download Clang Static Analyzer\n"
	printf "          -f | --no-fc          Ignore 42FileChecker tests\n"
	printf "          -l | --no-lftest      Ignore Libftest tests\n"
	printf "          -n | --no-clone       Do not clone 42FileChecker nor Libftest\n"
	printf "          -c | --no-cleanall    Do not remove 42fc libftest libft and static_analyzer\n"
	printf "          -g | --no-git         Copy the libft from a path on this machins\n"
	printf "          -h | --help           Prints this\n"
	exit
}

download_static_analyzer()
{
	printf "\e[32m----------\nDownloading clang static analyzer into $EFT_PATH_/static_analyzer\e[39m\n"
	curl -o checker-279.tar.bz2 https://clang-analyzer.llvm.org/downloads/checker-279.tar.bz2
	printf "\e[32m----------\nExtracting clang static analyzer...\e[39m\n"
	tar jxf checker-279.tar.bz2
	rm -rf checker-279.tar.bz2
	mv checker-279 static_analyzer
}

do_static_analyzer()
{
	printf "\e[32m----------\nUsing custom Makefile...\e[39m\n"
	mv $EFT_PATH_/libft/Makefile $EFT_PATH_/tmp
	cp $EFT_PATH_/files/Makefile $EFT_PATH_/libft

	printf "\e[32m----------\nChecking with scan-build...\e[39m\n"
	rm -rf $EFT_PATH_/reports/*
	$EFT_PATH_/static_analyzer/bin/scan-build -o $EFT_PATH_/reports --html-title "efouille X afrangio libftcheck - static analyzer report" --status-bugs make -C libft
	static_analyzer_errors=$(echo $?)
	make -C libft fclean

	printf "\e[32m----------\nRestoring original Makefile...\e[39m\n"
	rm $EFT_PATH_/libft/Makefile
	mv $EFT_PATH_/tmp/Makefile $EFT_PATH_/libft

	printf "\e[32mDone.\e[39m\nPress enter to continue"
	read
}

clone_tests()
{
	printf "\e[32m----------\nCloning 42FileChecker by jgigault into $EFT_PATH_/42fc...\e[39m\n"
	git clone https://github.com/jgigault/42FileChecker 42fc
	printf "\e[32m----------\nCloning libftest by jtoty (efouille fork) into $EFT_PATH_/libftest...\e[39m\n"
	git clone https://github.com/edrflt/Libftest.git libftest
}

do_42fc()
{
	printf "\e[32m----------\nChecking with 42FileChecker...\e[39m\n"
	cd $EFT_PATH_/42fc
	sh 42FileChecker.sh --project "libft" --path "$EFT_PATH_/libft"

	printf "\e[32mEnd of 42fc\e[39m\nPress enter to continue"
	read
}

do_lftest()
{
	printf "\e[32m----------\nChecking with libftest...\e[39m\n"
	cd $EFT_PATH_/libftest
	sh grademe.sh

	printf "\e[32mEnd of libftest\e[39m\nPress enter to continue"
	read
}

check_voids()
{
	voids=$(grep --color -nr "(void)" $EFT_PATH_/libft | wc | awk {'print $1'})
	if [ $voids -gt 0 ]
	then
		printf "\e[33m(void) FOUND HERE :\e[39m\n"
		grep --color -nr "(void)" $EFT_PATH_/libft
	else
		printf "\e[32mNo (void) found\e[39m\n"
	fi
}

show_report()
{
	$EFT_PATH_/static_analyzer/bin/scan-view $EFT_PATH_/reports/$(ls $EFT_PATH_/reports/)
}

LIB_PATH=""
CLEAN_ALL=true
DO_SA=true
DOWNLOAD_SA=true
REOPEN_REPORT=false
DO_42FC=true
DO_LFTEST=true
CLONE_TESTS=true
FROM_GIT=true

export EFT_PATH_="/tmp/eft_$(whoami)"

printf "\e[42m\e[30m  Automated tester by efouille X afrangio  \e[39m\e[49m\n"

if [ $# -eq 0 ]
then
	print_usage
fi

for arg in "$@"
do
	if [ $arg == "--help" -o $arg == "-h" ]
	then
		print_usage
    elif [ $arg == "--no-sa" -o $arg == "-s" ]
    then
    	DO_SA=false
    elif [ $arg == "--no-sa-down" -o $arg == "-d" ]
    then
    	DOWNLOAD_SA=false
    elif [ $arg == "--reopen-report" -o $arg == "-r" ]
    then
    	REOPEN_REPORT=true
    elif [ $arg == "--no-fc" -o $arg == "-f" ]
    then
    	DO_42FC=false
    elif [ $arg == "--no-lftest" -o $arg == "-l" ]
    then
    	DO_LFTEST=false
    elif [ $arg == "--no-clone" -o $arg == "-n" ]
    then
    	CLONE_TESTS=false
    elif [ $arg == "--no-cleanall" -o $arg == "-c" ]
    then
    	CLEAN_ALL=false
    elif [ $arg == "--no-git" -o $arg == "-g" ]
    then
    	FROM_GIT=false
    else
    	LIB_PATH=$arg
    fi
done

status=$(git status --porcelain | wc | awk {'print $1'})
if [ $status -gt 0 ]
then
	printf "\e[41m\e[30m                REPO CHANGED               \e[39m\e[49m\n"
	git status
fi

if ! $REOPEN_REPORT
then
	printf "\e[32mCreating $EFT_PATH_ working directory\e[39m\n"

	if $CLEAN_ALL
	then
		rm -rf $EFT_PATH_
	else
		rm -rf $EFT_PATH_/files
		rm -rf $EFT_PATH_/tmp
	fi
	mkdir -p $EFT_PATH_/files
	mkdir -p $EFT_PATH_/tmp

	printf "\e[32mCopying files\e[39m\n"
	cp ./Makefile $EFT_PATH_/files

	printf "\e[32mGoing to working dir\e[39m\n"
	cd $EFT_PATH_

	if $FROM_GIT
	then
		printf "\e[32m----------\nCloning libft into $EFT_PATH_/libft\e[39m\n"
		git clone $LIB_PATH libft
	else
		printf "\e[32m----------\nCopying libft into $EFT_PATH_/libft\e[39m\n"
		cp -R $LIB_PATH/ libft
	fi

	if $DOWNLOAD_SA
	then
		download_static_analyzer
	else
		printf "\e[33m----------\nClang Static Analyzer won't be downloaded (--no-sa-down)\e[39m\n"
	fi

	if $DO_SA
	then
		do_static_analyzer
	else
		printf "\e[33m----------\nIgnoring Clang Static Analyzer (--no-sa)\e[39m\n"
	fi

	if $CLONE_TESTS
	then
		clone_tests
	else
		printf "\e[33m----------\nTests won't be cloned (--no-clone)\e[39m\n"
	fi

	if $DO_42FC
	then
		do_42fc
	else
		printf "\e[33m----------\nIgnoring 42FileChecker (--no-fc)\e[39m\n"
	fi

	if $DO_LFTEST
	then
		do_lftest
	else
		printf "\e[33m----------\nIgnoring 42FileChecker (--no-lftest)\e[39m\n"
	fi

	check_voids

	if [ $static_analyzer_errors -gt 0 ]
	then
		show_report
	fi
else
	printf "\e[33m----------\nIgnoring everything to reopen report (--reopen-report)\e[39m\n"
	show_report
fi
