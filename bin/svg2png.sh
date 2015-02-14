#!/bin/bash

svg_to_png() {
    size=$1x$1
    density=$2
    dest_path=$3
    filename=$4

    # remove the dimension from destination filename
    out_filename=${filename//_[0-9]*px/}
    out_filename=ic_action_${out_filename//svg/png}
    mkdir -p $dest_path

    convert -density $density -background none \
    -fill white -opaque black \
    $filename \
    -resize $size -gravity center -extent $size $dest_path/`basename $out_filename`
}

base_dir=../../photoshelf/app/src/main/res
base_dir=../tmp
svg_file=../svg/draft_48px.svg
# svg_file=../tmp/converted.svg

# svg_to_png 24 300 $base_dir/drawable-mdpi $svg_file
# svg_to_png 36 300 $base_dir/drawable-hdpi $svg_file
# svg_to_png 48 300 $base_dir/drawable-xhdpi $svg_file
# svg_to_png 72 300 $base_dir/drawable-xxhdpi $svg_file

convert -background transparent ../tmp/converted.svg ../tmp/vediamo.png
    

# convert output.png -color-matrix \
#      " 1.5 0.0 0.0 0.0, 0.0, -0.157 \
#        0.0 1.5 0.0 0.0, 0.0, -0.157 \
#        0.0 0.0 1.5 0.0, 0.0, -0.157 \
#        0.0 0.0 0.0 1.0, 0.0,  0.0 \
#        0.0 0.0 0.0 0.0, 1.0,  0.0 \
#        0.0 0.0 0.0 0.0, 0.0,  1.0" output1.png

# convert output.png -fuzz XX% -fill "666666" -opaque "000000" output1.png


# convert output.png  -fill blue -opaque black   output1.png
# convert gradient: +level-colors 'black,blue' output.png output1.png