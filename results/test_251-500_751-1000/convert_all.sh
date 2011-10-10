#!/bin/sh
for f in *.txt; do ./result_conv.sh < $f > `basename $f .txt`.pred; done
