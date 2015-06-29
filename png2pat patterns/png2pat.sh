#!/bin/bash

ORG_DIR=`pwd`
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$DIR"

for pngfile in *.png
do
	#extension="${pngfile##*.}"
	filename="${pngfile%.*}"
	png2pat $pngfile > $filename.pat
done

cd "$ORG_DIR"
