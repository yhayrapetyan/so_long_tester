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

printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR};
printf ${YELLOW}"\n\t\tTEST CREATED BY: "${DEF_COLOR};
printf ${CYAN}"Me :)\t\n"${DEF_COLOR};
printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR};

rm -rf Test_results

FILE=$PWD/../so_long
INVALID_MAPS="$PWD/Test_maps/invalid"
OUTPUT="$PWD/Test_results"
TESTER=$PWD/check_leaks
ERRORS_COUNT=0

if [ -f "$FILE" ]; then
	echo -n
else
	printf "${RED}SO_LONG PROGRAM DOES NOT EXISTS${DEF_COLOR}\n";
	exit 1
fi

mkdir Test_results

cc $TESTER.c get_next_line.c get_next_line_utils.c -o check_leaks

subdirs=$(ls -d "$INVALID_MAPS"/* 2>/dev/null)

# Iterate over each subdirectory
for subdir in $subdirs; do
    subdir_name=$(basename "$subdir")
    printf "${MAGENTA}\n-------------------------------------------------------------\n${DEF_COLOR}"
    printf "${CYAN}                         $subdir_name\n"
    printf "${MAGENTA}-------------------------------------------------------------\n${DEF_COLOR}"
    mkdir $OUTPUT/$subdir_name
    for file_path in "$subdir"/*; do
        if [ -f "$file_path" ]; then
            file_name="${file_path##*/}"
            valgrind --leak-check=full "$FILE" "$file_path" > $OUTPUT/$subdir_name/$file_name 2>&1
            $TESTER "$OUTPUT/$subdir_name/$file_name"
            valgrind_exit_status=$?
            "$FILE" "$file_path"
            if [ $valgrind_exit_status -eq 0 ]; then
                printf "${GREEN}[OK LEAKS] ${DEF_COLOR}\n";
            else
                printf "${RED} [KO LEAKS] ${DEF_COLOR}\n";
                ((ERRORS_COUNT++))
            fi
        fi
    done
done

if [ "$ERRORS_COUNT" -ne 0 ]; then
    printf "${RED}\nProgram have some errors${DEF_COLOR}\n\n";
else
    printf "${GREEN}\nGood job! Everything works correctly${DEF_COLOR}\n\n"
fi

rm -rf $TESTER
