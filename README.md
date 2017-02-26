Used to simplify resource copy and generation (svg to png) 
run setup.sh to pull used repositories

Example

Create all drawables `40x40, 60x60, 80x80, 120x120, 160x160`

	baseOutputDir/drawable-mdpi/my.png
	baseOutputDir/drawable-hdpi/my.png
	baseOutputDir/drawable-xhdpi/my.png
	baseOutputDir/drawable-xxhdpi/my.png
	baseOutputDir/drawable-xxxhdpi/my.png

starting from the `my.svg` file

	run.sh 40 300 baseOutputDir my.svg
	
