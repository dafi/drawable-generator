#!/usr/local/opt/ruby/bin/ruby
# Copy resources from material-design-icons-master to specified project res directory
# All drawable-XXXX directories present on projects are filled
require 'open-uri'
require 'fileutils'
require "json"
require 'optparse'
require 'ostruct'

# copy the specified resource file to all drawable directories
# Params:
# +res_from_path+:: the full input resource file
# +drawable_root_dest_dir+:: the root destination directory containing all drawable-XXXX subdirectories
# +basename+:: the destination file name
def copy_res(res_from_path, drawable_root_dest_dir, basename = nil)
    res_path = ['drawable-hdpi', 'drawable-mdpi', 'drawable-xhdpi', 'drawable-xxhdpi', 'drawable-xxxhdpi']
    
    filename = basename ? basename : File.basename(res_from_path)
    if File.extname(filename).empty?
        filename = filename + File.extname(res_from_path);
    end
    res_path.each do |v|
        full_path = File.join(drawable_root_dest_dir, v)
        if File.exist?(full_path)
            src_path = res_from_path.gsub('$path$', v);
            full_path = File.join(full_path, filename)
            # puts "cp #{src_path} #{full_path}"
            FileUtils.cp(src_path, full_path)
        end
    end
end

# find the first path containing the passed filename
# the filename must be inside a 'drawable-XXX' directory
# This is very slow but affordable for our own use
# Params:
# +start+:: the start directory
# +filename+:: the filename to search
# Return:
# The fullpath found or nil
def find_first_path(start, filename)
    Dir.foreach(start) do |x|
        path = File.join(start, x)
        if x == '.' or x == '..'
            next
        elsif File.directory?(path)
            found_path = find_first_path(path, filename)
            if found_path
                return found_path
            end
        else
            if x == filename && path.include?('drawable-')
                return File.join(start, x)
            end
        end
    end
    return nil
end

def parse_command_line()
    cmd_opts = OpenStruct.new
    cmd_opts.dest_dir = '../../photoshelf/app/src/main/res'
    cmd_opts.src_dir = '../material-design-icons'

    optparser = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] config-file"
        opts.on('-d', '--dest root_dir', 'The root drawable-XXXX destination directory') do |value|
            cmd_opts.dest_dir = value
        end
        opts.on('-s', '--src root_dir', 'The source directory containing the resources to copy') do |value|
            cmd_opts.src_dir = value
        end
        opts.separator ''
        opts.on_tail('-h', '--help', 'This help text') do
            puts opts
            exit
        end
    end

    optparser.parse!

    if ARGV.empty?
        puts "config-file is mandatory"
        puts optparser
        exit
    end
    json_map = JSON.parse(open(ARGV[0]).read)
    options = OpenStruct.new(json_map)
    options.dest_dir = cmd_opts.dest_dir
    options.src_dir = cmd_opts.src_dir

    return options
end

options = parse_command_line()

options.resources.each do |k, v|
    next if k.start_with?('==>DISABLE_THIS')
    res_pattern = find_first_path(options.src_dir, k)
    if res_pattern.nil?
        puts "Unable to find #{k}"
        next
    end
    res_pattern.gsub!(/drawable-.*[\/\\]/, '$path$/')
    copy_res(res_pattern, options.dest_dir, v)
end
