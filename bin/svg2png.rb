require 'nokogiri'
require 'RMagick'
include Magick

def create_all(base_folder, filename, svg_data)
    folders = {
       'drawable-mdpi' => [18, 24, 36, 48],
       'drawable-hdpi' => [27, 36, 54, 72],
       'drawable-xhdpi' => [36, 48, 72, 96],
       'drawable-xxhdpi' => [54, 72, 108, 144],
       'drawable-xxxhdpi' => [72, 96, 144, 192]
    }
    dps = ['18dp', '24dp', '36dp', '48dp']

    folders.each do |folder, sizes|
        sizes.each_with_index do |size, i|
            dp = dps[i]
            save_png("#{base_folder}/#{folder}/ic_#{filename}_black_#{dp}.png", create_svg(svg_data, size, '000000'))
            save_png("#{base_folder}/#{folder}/ic_#{filename}_grey600_#{dp}.png", create_svg(svg_data, size, '757575'))
            save_png("#{base_folder}/#{folder}/ic_#{filename}_white_#{dp}.png", create_svg(svg_data, size, 'FFFFFF'))
        end
    end
end

def create_svg(data, size = 24, color = '000000', opacity = 1)
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

if ARGV.empty?
    puts "specify svg"
    exit
end
svg_input_path = ARGV[0]

# ignore namespace using local-name
if Nokogiri::XML(open(svg_input_path)).xpath("//*[local-name() = 'path']").count > 1
  puts "Only one path is allowed, please combine all"
  exit
end
svg_data = Nokogiri::XML(open(svg_input_path)).xpath("//*[local-name() = 'path']/@d").text

Dir.glob("../tmp/**/drawable*/*").each do |f| File.delete(f) end
create_all('../tmp', File.basename(svg_input_path, File.extname(svg_input_path)).gsub(/_[0-9]*px/, ''), svg_data)
