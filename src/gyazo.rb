#!/usr/bin/env ruby

require 'open3'
require 'json'
require 'yaml'
require_relative 'gyazo_client'

# setting
config_file = "#{ENV['HOME']}/.gyazo.config.yml"
opts = {}
opts = YAML.load_file(config_file) if File.exist?(config_file)

gyazo_client = GyazoClient.new(opts)

# collect metadata
active_window_id = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5`.chomp
out, err, status = Open3.capture3 "xwininfo -id #{active_window_id} | grep \"xwininfo: Window id: \"|sed \"s/xwininfo: Window id: #{active_window_id}//\""
active_window_name = out.chomp
out, err, status = Open3.capture3 "xprop -id #{active_window_id} | grep \"_NET_WM_PID(CARDINAL)\" | sed s/_NET_WM_PID\\(CARDINAL\\)\\ =\\ //"
pid = out.chomp
application_name = `ps -p #{pid} -o comm=`.chomp

# capture png file
temp = "/tmp/image_upload#{$$}.png"
image_file = ARGV[0]
if image_file && File.exist?(image_file)
  system "convert #{image_file} #{temp}"
else
  system "#{gyazo_client.capture_cmd} #{temp}"
end

fail 'No image data' unless File.exist?(temp)
image_data = File.read(temp)
File.delete(temp)

xuri = ""
if application_name =~ /(chrom(ium|e)|firefox|iceweasel)/
  xuri = `xdotool windowfocus #{active_window_id}; xdotool key "ctrl+l"; xdotool key "ctrl+c"; xclip -o`
end

metadata = JSON.generate({
  app: active_window_name,
  title: active_window_name,
  url: xuri,
  note: "#{active_window_name}\n#{xuri}"
})

gyazo_url = gyazo_client.upload(image_data, metadata)

if system "which #{gyazo_client.clipboard_cmd} >/dev/null 2>&1"
  system "echo -n '#{gyazo_url}' | #{gyazo_client.clipboard_cmd}"
end
system "#{gyazo_client.browser_cmd} '#{gyazo_url}'"
