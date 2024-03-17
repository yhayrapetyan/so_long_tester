#!/bin/bash

DEF_COLOR='\033[0;39m'
BLACK='\033[0;30m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
MAGENTA='\033[0;95m'
CYAN='\033[0;96m'
GRAY='\033[0;90m'
WHITE='\033[0;97m'

action=$1
default_action="default"

# Check if an argument is provided
if [ $# -eq 1 ]; then
    action=$1
else
    action=$default_action
fi


# Perform different actions based on the argument
case $action in
    clean)
        rm -rf Test_results
        printf ${BLUE}"\n-----------------------\n"${DEF_COLOR};
        printf ${GREEN}"  Test_results deleted"${DEF_COLOR};
        printf ${BLUE}"\n-----------------------\n\n"${DEF_COLOR};
        exit 0
        ;;
    default)
        ;;
    *)
        printf "${RED}Unknown action: ${YELLOW}$action\n${DEF_COLOR}"
        printf "${BLUE}Valid actions: ${GREEN}clean\n${DEF_COLOR}"
        exit 1
        ;;
esac

printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR};
printf ${YELLOW}"\n\t\tTEST CREATED BY: "${DEF_COLOR};
printf ${CYAN}"Me :)\t\n"${DEF_COLOR};
printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR};



rm -rf Test_results

PROGRAM=$PWD/../so_long
INVALID_MAPS="$PWD/Test_maps/invalid"
OUTPUT="$PWD/Test_results"
ERRORS_COUNT=0

make -C "$PWD/../" re

if [ -f "$PROGRAM" ]; then
	echo -n
else
	printf "${RED}SO_LONG PROGRAM DOES NOT EXISTS${DEF_COLOR}\n";
	exit 1
fi


mkdir Test_results


subdirs=$(ls -d "$INVALID_MAPS"/* 2>/dev/null)
# Iterate over each subdirectory
for subdir in $subdirs; do
    test_number=1
    subdir_name=$(basename "$subdir")
    printf "${MAGENTA}\n-------------------------------------------------------------\n${DEF_COLOR}"
    printf "${CYAN}                         $subdir_name\n"
    printf "${MAGENTA}-------------------------------------------------------------\n${DEF_COLOR}"
    mkdir $OUTPUT/$subdir_name
    for file_path in "$subdir"/*; do
        if [ -f "$file_path" ]; then
            file_name="${file_path##*/}"
            printf  "${CYAN}Test ${test_number}\n${DEF_COLOR}"
            valgrind_exit_status=$(valgrind --leak-check=full --show-leak-kinds=all --log-fd=1 $PROGRAM $file_path | grep -Ec 'no leaks are possible|ERROR SUMMARY: 0')
            valgrind --leak-check=full --show-leak-kinds=all "$PROGRAM" "$file_path" > $OUTPUT/$subdir_name/$file_name 2>&1
            if [[ $valgrind_exit_status == 2 ]]; then
                printf "${GREEN}[OK LEAKS] ${DEF_COLOR}\n";
            else
                printf "${RED} [KO LEAKS] ${DEF_COLOR}\n";
                ((ERRORS_COUNT++))
            fi
            ((test_number++))
        fi
    done
done

if [ "$ERRORS_COUNT" -ne 0 ]; then
    printf "${RED}\nProgram have some errors${DEF_COLOR}\n\n";
else
    printf "${GREEN}\nGood job! Everything works correctly${DEF_COLOR}\n\n"
fi
