#!/bin/bash

density_array=(1 1.5 2 3 4)
drawable_dir=(drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi drawable-xxxhdpi)
size=${1:-24}
density=${2:-300}

svg_to_png() {
    local size=$1x$1
    local density=$2
    local dest_path=$3
    local filename=$4

    # remove the dimension from destination filename
    local out_filename=${filename//_[0-9]*px/}
    local out_filename=ic_action_${out_filename//svg/png}
    mkdir -p $dest_path

    convert -density $density -background none \
    -fill white -opaque black \
    $filename \
    -resize $size -gravity center -extent $size $dest_path/`basename $out_filename`

    echo created $dest_path/`basename $out_filename`
}



base_dir=../../photoshelf/app/src/main/res
svg_file=../svg/draft_48px.svg
# svg_file=../tmp/converted.svg

# base_dir=../tmp
svg_file=../svg/bookmark_border.svg

for i in "${!density_array[@]}"; do
    size_density=`bc <<< "scale=0;($size*${density_array[$i]})/1"`
    svg_to_png $size_density $density $base_dir/${drawable_dir[$i]} $svg_file
done

# svg_to_png 40 300 ../tmp/drawable-mdpi ../svg/bookmark_green.svg

# svg_to_png 40 300 $base_dir/drawable-mdpi $svg_file
# svg_to_png 80 300 $base_dir/drawable-hdpi $svg_file
# svg_to_png 160 300 $base_dir/drawable-xhdpi $svg_file
# svg_to_png 320 300 $base_dir/drawable-xxhdpi $svg_file

# svg_to_png 24 300 $base_dir/drawable-mdpi $svg_file
# svg_to_png 36 300 $base_dir/drawable-hdpi $svg_file
# svg_to_png 48 300 $base_dir/drawable-xhdpi $svg_file
# svg_to_png 72 300 $base_dir/drawable-xxhdpi $svg_file

# convert -background transparent ../tmp/converted.svg ../tmp/vediamo.png
    

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