#!/bin/bash

# Create copies of each file type
#dirs=($(find . -not -path "./.git/*" -mindepth 1 -type d))

dirs=($(find ./unstructured/ -mindepth 1 -type d))

for dir in "${dirs[@]}";
do
	cd "$dir"
        while read p;
	do
                if [ "$p" != "filenames.txt" ]; then
                        for (( i=0; i<100; ++i)); do
                                cp "$p" $i-"$p"
                        done
                else
                        echo "Working on" "$dir"
                fi
        done < filenames.txt
        cd "../.."
done
