##
# Convert SVG files to PNG to be used with Android.
#
# The PNG files are created inside the directories:
# drawable-hdpi, drawable-mdpi, drawable-xhdpi, drawable-xxhdpi, drawable-xxxhdpi
#
# == Author
# Davide Ficano https://github.com/dafi
#
# == Credits
# The script is based on https://github.com/Templarian code
# Visit https://github.com/google/material-design-icons/issues/62#issuecomment-68640868 for more informations

require 'nokogiri'
require 'RMagick'
require 'optparse'
require 'ostruct'

include Magick

$folders = {
   'drawable-mdpi' => [18, 24, 36, 48],
   'drawable-hdpi' => [27, 36, 54, 72],
   'drawable-xhdpi' => [36, 48, 72, 96],
   'drawable-xxhdpi' => [54, 72, 108, 144],
   'drawable-xxxhdpi' => [72, 96, 144, 192]
}
$dps = ['18dp', '24dp', '36dp', '48dp']

def create_all_drawables(base_folder, filename, svg_data)
    $folders.each do |folder, sizes|
        sizes.each_with_index do |size, i|
            dp = $dps[i]
            save_png("#{base_folder}/#{folder}/ic_#{filename}_black_#{dp}.png", create_svg_xml(svg_data, size, '000000'))
            save_png("#{base_folder}/#{folder}/ic_#{filename}_grey600_#{dp}.png", create_svg_xml(svg_data, size, '757575'))
            save_png("#{base_folder}/#{folder}/ic_#{filename}_white_#{dp}.png", create_svg_xml(svg_data, size, 'FFFFFF'))
        end
    end
end

def create_svg_xml(data, size = 24, color = '000000', opacity = 1)
    foreground_hex = color == "000000" ? '' : "fill=\"##{color}\""
    foreground_opacity = opacity == 1 ? '' : "fill-opacity=\"#{opacity}\""
    return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" <<
      "<svg width=\"#{size}\" height=\"#{size}\" viewBox=\"0 0 24 24\">" <<
      "<path #{foreground_hex}#{foreground_opacity} d=\"#{data}\" />" <<
      "</svg>"
end

def save_png(path, data)
    img = Image.from_blob(data) {
      self.background_color = 'transparent'
      self.format = 'png32'
    }
    img.first.write(path)
end

# def save_png(path, data)
#     temp_path = path + "temp.svg"
#     File.open(temp_path, 'w') {|f| f.write(data) }
#     `convert -background transparent #{temp_path} #{path}`
#     File.delete(temp_path)
# end

def parse_command_line()
    cmd_opts = OpenStruct.new
    cmd_opts.recursive = false
    cmd_opts.clean = false

    optparser = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] svg_path"
        opts.on('-d', '--dest_dir dir', 'The root drawable-XXXX destination directory') do |value|
            cmd_opts.dest_dir = value
        end
        opts.on('-r', '--recursive', 'The svg_path must be a directory and will be traversed to convert all svg files') do |value|
            cmd_opts.recursive = value
        end
        opts.on('-c', '--clean-drawable', 'remove all files present in drawable-XXXX dest_dir\'s subfolders') do |value|
            cmd_opts.clean = value
        end
        opts.separator ''
        opts.on_tail('-h', '--help', 'This help text') do
            puts opts
            exit
        end
    end

    begin
      optparser.parse!

      if !ARGV.empty?
          cmd_opts.svg_path = ARGV[0]
      end

      mandatory = ["svg_path", "dest_dir"]
      missing = mandatory.select{ |param| cmd_opts.send(param).nil? }
      if not missing.empty?
          puts "Missing options: #{missing.join(', ')}"
          puts optparser
          exit
      end
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts optparser
      exit
    end

    if !File.exist?(cmd_opts.svg_path)
      puts "#{cmd_opts.svg_path} not found"
      exit
    end

    if cmd_opts.recursive && !File.directory?(cmd_opts.svg_path)
      puts "#{cmd_opts.svg_path} must be a valid directory when recursive flag is on"
      exit
    end

    if !File.exist?(cmd_opts.dest_dir) || !File.directory?(cmd_opts.dest_dir)
      puts "#{cmd_opts.dest_dir} must be a valid directory"
      exit
    end

    return cmd_opts
end

def convert_svg_to_pngs(svg_file, dest_dir)
  paths = Nokogiri::XML(open(svg_file)).xpath("//*[local-name() = 'path']")
  if paths.count > 1
    puts "#{svg_file} can be converted because contains more than on path, please combine all"
    return
  end

  # get only filename without extension and "px" suffix (eg _24px)
  filename = File.basename(svg_file, File.extname(svg_file)).gsub(/_[0-9]*px/, '')
  create_all_drawables(dest_dir, filename, paths.xpath("@d").text)
end

options = parse_command_line

# Create drawable directories
$folders.each do |folder, sizes|
  dirname = File.join(options.dest_dir, folder)
  Dir.mkdir(dirname) if !File.exist?(dirname)
end

Dir.glob(File.join(options.dest_dir, "**", "drawable*", "*")).each do |f| File.delete(f) end if options.clean
if options.recursive
  Dir.glob(File.join(options.svg_path, "**", "*.svg")).each do |f| convert_svg_to_pngs(f, options.dest_dir) end
else
  if File.directory?(options.svg_path)
      Dir.glob(File.join(options.svg_path, "*.svg")).each do |f| convert_svg_to_pngs(f, options.dest_dir) end
  else
    convert_svg_to_pngs(options.svg_path, options.dest_dir)
  end
end

