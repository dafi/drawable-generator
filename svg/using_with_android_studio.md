# Using SVG files with Android Studio

### Extract SVG

The single SVG files are contained into an SVG font so they are extracted using the script

	extract_svg_from_svgfont.rb

### Resize to 24x24 pixel

Android Studio requires icons 24x24 pixel size

The extracted `viewBox` is 1500x1500 pixels and the image could be not fully visible so it's necesary to adjust it

Using Inkscape the result are odd (Android Studio doesn't show correcty the image) so we used Affinity Designer

#### Affinity Designer

1. Open the SVG
2. Resize the image **height** to 24px (the width must be proportional)
3. Change the document size from 1500x1500 to 24x24
4. If the icon will be not visible then change the document size step by step
	1. 1500x1500 to 800x800
	2. 800x800 to 400x400
	3. 400x400 to 200x200
	4. 200x200 to 24x24 (finally!)

### Optimize the SVG file size

The final SVG size could be big and Android Studio could show a lint warning

The size can be reduced using [svgo](https://github.com/svg/svgo)
