#!/bin/sh
# convert weka results to simple space-separated format:
# <id> <probability>
grep -E "^ +[0-9]+ +[0-9]:[0-9]" - | tr -d ':+*()' | awk '{print $6, $5}'
