#!/bin/bash
# This script takes an image and makes 256x256 tiles. Works well with big images.
#
# Usage: ./big_image_tiler.sh <image_name> <prefix>

if (( $# != 2 )); then
    echo "Usage: ./big_image_tiler.sh <image_name> <prefix>"
    exit 1
fi

size=256
name=$2
mkdir $name
convert  -gravity NorthWest -monitor -limit area 2mb $1 myLargeImg.mpc
src=myLargeImg.mpc
width=`identify -format %w $src`
height=`identify -format %h $src`
echo "width: $width"
echo "height: $height"
w_limit=$[$width / $size]
h_limit=$[$height / $size]
echo "count = $w_limit * $h_limit = "$((w_limit * h_limit))" tiles"
w_limit=$((w_limit))
h_limit=$((h_limit))
for x in `seq 0 $w_limit`; do
  for y in `seq 0 $h_limit`; do
    tile=$name/$name\_$x\_$y.jpg
    echo -n $tile
    w=$((x * size))
    h=$((y * size))
    convert -monitor $src -gravity NorthWest -crop $size\x$size+$w+$h $tile
    # convert -debug cache -monitor $src -gravity NorthWest -crop $size\x$size+$w+$h $tile
  done
done
rm myLargeImg.*