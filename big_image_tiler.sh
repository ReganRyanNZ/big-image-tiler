#!/bin/bash
# This script takes an image and makes 256x256 tiles. Works well with big images.
#
# Usage: ./big_image_tiler.sh <image_name> <prefix>

if (( $# != 2 )); then
    echo "Usage: ./big_image_tiler.sh <image_name> <prefix>"
    exit 1
fi

name=$2
mkdir $name
convert -monitor -limit area 2mb $1 myLargeImg.mpc
src=myLargeImg.mpc
width=`identify -format %w $src`
limit=$[$width / 256]
echo "count = $limit * $limit = "$((limit * limit))" tiles"
limit=$((limit-1))
for x in `seq 0 $limit`; do
  for y in `seq 0 $limit`; do
    tile=$name/$name\_$x\_$y.png
    echo -n $tile
    w=$((x * 256))
    h=$((y * 256))
    convert -debug cache -monitor $src -crop 256x256+$w+$h $tile
  done
done
rm myLargeImg.*