#!/usr/bin/env ruby
require 'nokogiri'
require 'fileutils'

# Extract all <glyph/>s contained inside an SVG font file
# Every glyph is saved as SVG and converted into a <path/>
# The SVG file name is an incremental number or
# if present, the glyph-name attribute value

# This script il largely inspired by
# http://helpfulsheep.com/2015-03-25-converting-svg-fonts-to-svg/

def extract_svg(svg_font, output_dir)
  doc = Nokogiri::XML(open(svg_font)).remove_namespaces!

  doc.xpath('//glyph').each_with_index do |glyph, i|
    file_name = glyph.attr('glyph-name') || format('%04d', i)
    full_path = File.join(output_dir, "#{file_name}.svg")
    puts "Extracting #{file_name}..."
    write_file_from_glyph(Hash[glyph.to_a], full_path)
  end
end

# rubocop:disable Metrics/MethodLength
def write_file_from_glyph(glyph_attrs, full_path)
  open(full_path, 'wb') do |file|
    file << %{<?xml version="1.0" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg"
  version="1.1"
  width="1500px"
  height="1500px">
<path transform="scale(1, -1) translate(0, -1500)"}
    glyph_attrs.each { |h, k| file << " #{h}=\"#{k}\"" }
    file << %(/>
</svg>
)
  end
end

if ARGV.empty?
  puts 'syntax: <svg_font> (output_dir)'
  exit 1
end

svg_font_path = ARGV[0]
output_dir = ARGV.length > 1 ? ARGV[1] : './extracted_svg'

FileUtils.mkdir_p output_dir unless File.exist?(output_dir)

extract_svg(svg_font_path, output_dir)
