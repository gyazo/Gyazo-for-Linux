#!/usr/bin/env ruby

# setting
browser_cmd = 'xdg-open'
clipboard_cmd = 'xclip'

require 'net/http'
require 'open3'
require 'json'

# get id
idfile = ENV['HOME'] + "/.gyazo.id"

id = ''
if File.exist?(idfile) then
  id = File.read(idfile).chomp
end

# get active window name

active_window_id = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5`.chomp
out, err, status = Open3.capture3 "xwininfo -id #{active_window_id} | grep \"xwininfo: Window id: \"|sed \"s/xwininfo: Window id: #{active_window_id}//\""
active_window_name = out.chomp
out, err, status = Open3.capture3 "xprop -id #{active_window_id} | grep \"_NET_WM_PID(CARDINAL)\" | sed s/_NET_WM_PID\\(CARDINAL\\)\\ =\\ //"

pid = out.chomp

application_name = `ps -p #{pid} -o comm=`.chomp
# capture png file
tmpfile = "/tmp/image_upload#{$$}.png"
imagefile = ARGV[0]

if imagefile && File.exist?(imagefile) then
  system "convert '#{imagefile}' '#{tmpfile}'"
else
  system "import '#{tmpfile}'"
end

if !File.exist?(tmpfile) then
  exit
end

imagedata = File.read(tmpfile)
File.delete(tmpfile)

xuri = ""
if application_name =~ /(chrom(ium|e)|firefox|iceweasel)/
  xuri = `xdotool windowfocus #{active_window_id}; xdotool key "ctrl+l"; xdotool key "ctrl+c"; xclip -o`
end


# upload
boundary = '----BOUNDARYBOUNDARY----'

# endpoint https://gyazo.com/api/docs
HOST = 'upload.gyazo.com'
CGI = '/upload.cgi'
UA   = 'Gyazo/1.2'

metadata = JSON.generate({
  app: active_window_name,
  title: active_window_name,
  url: xuri,
  note: "#{active_window_name}\n#{xuri}"
})

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
  'User-Agent' => UA
}

env = ENV['http_proxy']
if env then
  uri = URI(env)
  proxy_host, proxy_port = uri.host, uri.port
else
  proxy_host, proxy_port = nil, nil
end
https = Net::HTTP::Proxy(proxy_host, proxy_port).new(HOST,443)
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5
https.start{
  res = https.post(CGI,data,header)
  url = res.response.body
  puts url
  if system "which #{clipboard_cmd} >/dev/null 2>&1" then
    system "echo -n '#{url}' | #{clipboard_cmd}"
  end
  system "#{browser_cmd} '#{url}'"

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
