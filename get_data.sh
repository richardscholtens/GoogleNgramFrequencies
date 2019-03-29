#!/bin/bash
# Author: J. F. P. (Richard) Scholtens
# This program extracts data from the Googl Ngram dataset version 20120701
# The data within these datasets is formatted in the following way:
# ngram TAB year TAB match_count TAB volume_count NEWLINE
# For example:
# grey    1988    84121   13926


# By changing the IFS code newlines will keep exsisting when stored to variables.
IFS=

# All Google Ngram dataset filenames.
a=googlebooks-eng-all-1gram-20120701-a
c=googlebooks-eng-all-1gram-20120701-c
f=googlebooks-eng-all-1gram-20120701-f
g=googlebooks-eng-all-1gram-20120701-g
m=googlebooks-eng-all-1gram-20120701-m


# Format for printing tables.
divider===============================
divider=$divider$divider$divider$divider
header="\n%-25s|%19s|%19s|%19s|\n"
format="%-25s|%19s|%19s|%19s|\n"
width=100


get_frequencies () {

	# Frequencies of word and books for the first word seperated by 1900/1945 and 1946/1999.
	word1fr_0045=$(cat $1 | grep -wi "\<"$2"\>" | awk '$2 >= 1900 && $2 <=1945' | awk '{sum += $3} END {print sum}')
	word1fr_4699=$(cat $1 | grep -wi "\<"$2"\>" | awk '$2 >= 1946 && $2 <=1999' | awk '{sum += $3} END {print sum}')

	word2fr_0045=$(cat $1 | grep -wi "\<"$3"\>" | awk '$2 >= 1900 && $2 <=1945' | awk '{sum += $3} END {print sum}')
	word2fr_4699=$(cat $1 | grep -wi "\<"$3"\>" | awk '$2 >= 1946 && $2 <=1999' | awk '{sum += $3} END {print sum}')


	# If variables are empty it will be given the number 0..
	[ -z "$word1fr_0045" ] && word2fr_0045=0
	[ -z "$word1fr_4699" ] && word2fr_4699=0
	[ -z "$word2fr_0045" ] && word2fr_0045=0
	[ -z "$word2fr_4699" ] && word2fr_4699=0

	# Sum up total frequency words column.
	total_word_c1=$((word1fr_0045 + $word2fr_0045))
	total_word_c2=$((word1fr_4699 + $word2fr_4699))

	# Sum up total frequency words row.
	total_word_r1=$((word1fr_0045 + $word1fr_4699))
	total_word_r2=$((word2fr_0045 + $word2fr_4699))
	total_word=$((total_word_r1 + total_word_r2))

	# Print table to display word frequencies.
	echo -e "\n###" $2/$3 "###" >> frequency_tables.out
	printf "$header" "Frequency words" "Before 1945" "After 1945" "Total" >> frequency_tables.out
	printf "%$width.${width}s\n" "$divider" >> frequency_tables.out
	printf "$format" \
	"British "$2  $word1fr_0045 $word1fr_4699 $total_word_r1\
	"American "$3  $word2fr_0045 $word2fr_4699 $total_word_r2 >> frequency_tables.out
	printf "%$width.${width}s\n" "$divider" >> frequency_tables.out
	printf "$format" \
	"Total " $total_word_c1 $total_word_c2 $total_word >> frequency_tables.out

	python3 chi_square.py "$total_word_c1" "$total_word_c2" "$total_word_r1" "$total_word_r2" "$total_word" "$word1fr_0045" "$word1fr_4699" "$word2fr_0045" "$word2fr_4699" "$2" "$3" >> frequency_tables.out

}


# Get frequency information from words.
get_frequencies $a "Aluminium" "Aluminum"
get_frequencies $c "Colour" "Color"
get_frequencies $f "Flexitime" "Flextime"
get_frequencies $g "Grey" "Gray"
get_frequencies $m "Mum" "Mom"
