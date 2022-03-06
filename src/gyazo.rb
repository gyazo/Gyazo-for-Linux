#!/usr/bin/env ruby

require 'net/http'
require 'open3'
require 'openssl'
require 'json'
require 'yaml'

# setting
configfile = "#{ENV['HOME']}/.gyazo.config.yml"
config = {}
if File.exist?(configfile) then
  config = YAML.load_file(configfile)
end

#If config file exists but is empty, set to {} to prevent future errors
if config == false then
  config = {}
end

browser_cmd = config['browser_cmd'] || 'xdg-open'
clipboard_cmd = config['clipboard_cmd'] || 'xclip'
clipboard_opt = config['clipboard_opt'] || '-sel clip'
host = config['host'] || 'upload.gyazo.com'
cgi = config['cgi'] || '/upload.cgi'
ua = config['ua'] || 'Gyazo/1.3.1'
http_port = config['http_port'] || 443
use_ssl = config['use_ssl'] == nil ? 'true' : config['use_ssl']
copy_target = config['copy_target'] || 'link'
#False would trigger the || condition if using the syntax above
open_browser = true
if config['open_browser'] != nil
  open_browser = config['open_browser']
end

# get id
idfile = ENV['HOME'] + "/.gyazo.id"

id = ''
if File.exist?(idfile) then
  id = File.read(idfile).chomp
end

# get active window name

window_property = "_NET_ACTIVE_WINDOW(WINDOW)"
active_window_id = "xprop -root | grep window_property | cut -d ' ' -f 5".chomp
out, err, status = Open3.capture3 "xwininfo -id #{active_window_id} | grep \"xwininfo: Window id: \"|sed \"s/xwininfo: Window id: #{active_window_id}//\""
active_window_name = out.chomp
out, err, status = Open3.capture3 "xprop -id #{active_window_id} | grep \"_NET_WM_PID(CARDINAL)\" | sed s/_NET_WM_PID\\(CARDINAL\\)\\ =\\ //"

pid = out.chomp

application_name = `ps -p #{pid} -o comm=`.chomp
# capture png file
tmpfile = "/tmp/image_upload#{$$}.png"
imagefile = ARGV[0]

if imagefile && File.exist?(imagefile) then
  out, err, status = Open3.capture3 "identify '#{imagefile}'"
  if out.split("\n").size > 1 # NOTE: gif animation
    system "cp '#{imagefile}' '#{tmpfile}'"
  else
    system "convert '#{imagefile}' '#{tmpfile}'"
  end
else
  command = config['command'] || 'import'
  system "#{command} '#{tmpfile}'"
end

if !File.exist?(tmpfile) then
  exit
end

imagedata = File.read(tmpfile)

xuri = ""
if application_name =~ /(chrom(ium|e)|firefox|iceweasel)/
  xuri = `xdotool windowfocus #{active_window_id}; xdotool key "ctrl+l"; xdotool key "ctrl+c"; xclip -o`
end


# upload
boundary = '----BOUNDARYBOUNDARY----'

metadata = JSON.generate({
  app: active_window_name,
  title: active_window_name,
  url: xuri,
  note: "#{active_window_name}\n#{xuri}"
})

data = <<EOF
--#{boundary}\r
content-disposition: form-data; name="metadata"\r
\r
#{metadata}\r
--#{boundary}\r
content-disposition: form-data; name="id"\r
\r
#{id}\r
--#{boundary}\r
content-disposition: form-data; name="imagedata"; filename="gyazo.com"\r
\r
#{imagedata}\r
--#{boundary}--\r
EOF

header ={
  'Content-Length' => data.length.to_s,
  'Content-type' => "multipart/form-data; boundary=#{boundary}",
  'User-Agent' => ua,
  'X-Gyazo-Accept-Token' => 'required'
}

env = ENV['http_proxy']
if env then
  uri = URI(env)
  proxy_host, proxy_port = uri.host, uri.port
else
  proxy_host, proxy_port = nil, nil
end
https = Net::HTTP::Proxy(proxy_host, proxy_port).new(host,http_port)
https.use_ssl = use_ssl
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5
https.start{
  res = https.post(cgi,data,header)
  url = res.response.body
  puts url
  if system "which #{clipboard_cmd} >/dev/null 2>&1" then
    if copy_target == "image" and clipboard_cmd == "xclip" then
      system "xclip #{clipboard_opt} -t image/png -i #{tmpfile}"
    elsif copy_target == "direct" then
      system "echo -n '#{url}.png' | #{clipboard_cmd} #{clipboard_opt}"
    else
      system "echo -n '#{url}' | #{clipboard_cmd} #{clipboard_opt}"
    end    
  end
  openUrl = url
  if token = res.response['X-Gyazo-Session-Token']
    openUrl += "?token=#{token}"
  end
  if(open_browser == true) then
    system "#{browser_cmd} '#{openUrl}'"
  end

  # save id
  newid = res.response['X-Gyazo-Id']
  if newid and newid != "" then
    if !File.exist?(File.dirname(idfile)) then
      Dir.mkdir(File.dirname(idfile))
    end
    if File.exist?(idfile) then
      File.rename(idfile, idfile+Time.new.strftime("_%Y%m%d%H%M%S.bak"))
    end
    File.open(idfile,"w").print(newid)
  end
}

File.delete(tmpfile)

