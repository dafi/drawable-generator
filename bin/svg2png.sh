#!/bin/bash

svg_to_png() {
    size=$1x$1
    density=$2
    dest_path=$3
    filename=$4

    # -fill black -opaque white \
    out_filename=ic_action_${filename//svg/png}
    convert -density $density -background none \
    $filename \
    -resize $size -gravity center -extent $size $dest_path/`basename $out_filename`
}

base_dir=../../photoshelf/app/src/main/res

svg_to_png 24 300 $base_dir/drawable-mdpi draft.svg
svg_to_png 36 300 $base_dir/drawable-hdpi draft.svg
svg_to_png 48 300 $base_dir/drawable-xhdpi draft.svg
svg_to_png 72 300 $base_dir/drawable-xxhdpi draft.svg

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