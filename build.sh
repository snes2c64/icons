#!/usr/bin/env bash
set -e

if [[ -z "$1" ]]; then

find build -type f -not -name "*.scad" -delete



find build -type f -not -name icons.scad -name "*.scad" -print0 | xargs -0 -P $(nproc) -i  "$0" scad2svg "{}"

(
cd build
php ../snesbuttons.php
)
find build -name "*.svg"  -print0 | xargs -0 -P $(nproc) -i "$0" svg2png "{}" \;

mkdir dist
find dist -type f -delete
find build -type f -not -name "*.scad" -exec cp "{}" dist \;


fi

case "$1" in

"scad2svg")
  openscad --enable textmetrics -o "$2.svg" "$2"
  mv "$2.svg" "${2%.scad}.svg"
  ;;
"svg2png")
  convert -background none -density 600 "$2" "$2.png"
  mv "$2.png" "${2%.svg}.png"
  ;;

esac