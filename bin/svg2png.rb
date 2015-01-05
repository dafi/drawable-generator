require 'nokogiri'
require 'RMagick'
include Magick

# home brew
# gem install rmagick

def create_all(base_folder, svg_data)
    folders = {
       'drawable-mdpi' => [18, 24, 36, 48],
       'drawable-hdpi' => [27, 36, 54, 72],
       'drawable-xhdpi' => [36, 48, 72, 96],
       'drawable-xxhdpi' => [54, 72, 108, 144],
       'drawable-xxxhdpi' => [72, 96, 144, 192]
    }
    dps = ['18dp', '24dp', '36dp', '48dp']

    name = 'draft'
    folders.each do |folder, sizes|
        sizes.each_with_index do |size, i|
            dp = dps[i]
            icon_png_blob("#{base_folder}/#{folder}/ic_#{name}_black_#{dp}.png", create_svg(svg_data, size, '000000'))
            icon_png_blob("#{base_folder}/#{folder}/ic_#{name}_grey600_#{dp}.png", create_svg(svg_data, size, '757575'))
            icon_png_blob("#{base_folder}/#{folder}/ic_#{name}_white_#{dp}.png", create_svg(svg_data, size, 'FFFFFF'))
        end
    end
end

def create_svg(data, size = 24, color = '000000', opacity = 1)
    foreground_hex = color == "000000" ? '' : "fill=\"##{color}\""
    foreground_opacity = opacity == 1 ? '' : "fill-opacity=\"#{opacity}\""
    svg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" <<
     "<svg" <<
   # " xmlns:dc=\"http://purl.org/dc/elements/1.1/\" " <<
   # " xmlns:cc=\"http://creativecommons.org/ns#\"" <<
   # " xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"" <<
   # " xmlns:svg=\"http://www.w3.org/2000/svg\"" <<
   # " xmlns=\"http://www.w3.org/2000/svg\"" <<
   # " version=\"1.1\"" <<
   # " id=\"svg2\"" <<
   " width=\"#{size}\" height=\"#{size}\" viewBox=\"0 0 24 24\">" <<
    "<path #{foreground_hex}#{foreground_opacity} d=\"#{data}\" />" <<
    "</svg>"
    return svg
end

def icon_png_blob(path, data)
    temp_path = path + "temp.svg"
    File.open(temp_path, 'w') {|f| f.write(data) }
    `convert -background transparent #{temp_path} #{path}`
    File.delete(temp_path)
end


url = '../svg/draft_24px.svg'
size = 192
color = 'FFFFFF' #757575';

# ignore namespace using local-name
svg_data = Nokogiri::XML(open(url)).xpath("//*[local-name() = 'path']/@d").text
# svg_xml = create_svg(svg_data, size, color)

create_all('../tmp', svg_data)
# img = ImageList.new(url)
# img.write("../tmp/mio_ruby.svg")
#  {
#  self.background_color = 'Transparent'
# }
# img.write("../tmp/mio_ruby.svg")

# File.open("../tmp/mio-ruby-cmd.svg", 'w') {|f| f.write(svg_xml) }
# `convert -background transparent ../tmp/mio-ruby-cmd.svg ../tmp/mio-ruby-cmd.png`