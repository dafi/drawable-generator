#!/usr/local/opt/ruby/bin/ruby
# Copy resources from material-design-icons-master to specified project res directory
# All drawable-XXXX directories present on projects are filled
require 'fileutils'

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
            puts "cp #{src_path} #{full_path}"
            # FileUtils.cp(src_path, full_path)
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

dest_res_dir = '../../photoshelf/app/src/main/res'
src_res_dir = '../material-design-icons'

# map containing the src filename and the destination filename
# full src res path is search so it isn't necessary to determine it manually
files_to_copy = {
'ic_select_all_white_24dp.png'      => 'ic_action_select_all.png',
# 'ic_file_upload_white_24dp.png'     => 'ic_action_file_upload.png',
'ic_delete_white_24dp.png'          => 'ic_action_delete.png',
'ic_cloud_download_white_24dp.png'  => 'ic_action_download.png',
'ic_mode_edit_white_24dp.png'       => 'ic_action_edit.png',
'ic_cloud_upload_white_24dp.png'    => 'ic_action_cloud_upload.png',
'ic_remove_red_eye_white_24dp.png'  => 'ic_action_show_image.png',
'ic_publish_white_24dp.png'         => 'ic_action_publish.png',
'ic_refresh_white_24dp.png'         => 'ic_action_refresh.png',
'ic_schedule_white_24dp.png'        => 'ic_action_schedule.png',
'ic_now_wallpaper_white_24dp.png'   => 'ic_action_set_wallpaper.png',
'ic_search_white_24dp.png'          => 'ic_action_search.png',
'ic_share_white_24dp.png'           => 'ic_action_share',
'ic_people_outline_white_24dp.png'  => 'ic_action_mark_ignored'
}

files_to_copy.each do |k, v|
    res_pattern = find_first_path(src_res_dir, k)
    if res_pattern.nil?
        puts 'Unable to find #{k}'
        next
    end
    res_pattern.gsub!(/drawable-.*[\/\\]/, '$path$/')
    copy_res(res_pattern, dest_res_dir, v)
end

