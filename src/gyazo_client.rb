require 'net/http'
require 'open3'
require 'openssl'
require 'open3'
require 'json'

class GyazoClient

  def initialize(opts = {})
    default_opts = {
      id_file:           ENV['HOME'] + "/.gyazo.id",
      capture_cmd:       'import',
      browser_cmd:       'xdg-open',
      clipboard_cmd:     'xclip',
      host:              'upload.gyazo.com',
      cgi:               '/upload.cgi',
      ua:                'Gyazo/1.2',
      port:               443,
      use_ssl:            true
    }

    opts = default_opts.merge(opts)

    opts.each do |key, value|
      self.class.class_eval { attr_accessor "#{key}" }
      self.instance_variable_set "@#{key}", value
    end
  end

  def upload(image_data)
    boundary = '----BOUNDARYBOUNDARY----'

    data = <<EOF
--#{boundary}\r
content-disposition: form-data; name="metadata"\r
\r
#{metadata}\r
--#{boundary}\r
content-disposition: form-data; name="id"\r
\r
#{device_id}\r
--#{boundary}\r
content-disposition: form-data; name="imagedata"; filename="gyazo.com"\r
\r
#{image_data}\r
--#{boundary}--\r
EOF

    header ={
      'Content-Length' => data.length.to_s,
      'Content-type' => "multipart/form-data; boundary=#{boundary}",
      'User-Agent' => @ua
    }

    if @http_proxy
      proxy = URI.parse(@http_proxy)
      @proxy_host, @proxy_port = proxy.host, proxy.port
    end

    https = Net::HTTP::Proxy(@proxy_host, @proxy_port).new(@host, @port)
    https.use_ssl = @use_ssl
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    res = https.post(@cgi, data, header)
    gyazo_url = res.response.body

    new_id = res.response['X-Gyazo-Id']
    save_id(new_id) if new_id && new_id != ''

    gyazo_url
  end

  def metadata
    JSON.generate(
      {
        app:   active_window_name,
        title: active_window_name,
        url:   browser_url,
        note:  "#{active_window_name}\n#{browser_url}"
      })
  end

  def active_window_id
    `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5`.chomp
  end

  def active_window_name
    out, err, status = Open3.capture3 "xwininfo -id #{active_window_id} | grep \"xwininfo: Window id: \"|sed \"s/xwininfo: Window id: #{active_window_id}//\""
    out.chomp
  end

  def application_name
    out, err, status = Open3.capture3 "xprop -id #{active_window_id} | grep \"_NET_WM_PID(CARDINAL)\" | sed s/_NET_WM_PID\\(CARDINAL\\)\\ =\\ //"
    pid = out.chomp
    application_name = `ps -p #{pid} -o comm=`.chomp
  end

  def browser_url
    if application_name =~ /(chrom(ium|e)|firefox|iceweasel)/
      return `xdotool windowfocus #{active_window_id}; xdotool key "ctrl+l"; xdotool key "ctrl+c"; xclip -o`
    end
    ''
  end

  def copy_to_clipboard(url)
    if system "which #{@clipboard_cmd.split(' ')[0]} >/dev/null 2>&1"
      system "echo -n '#{url}' | #{@clipboard_cmd}"
    end
  end

  def open_browser(url)
    system "#{@browser_cmd} '#{url}'"
  end

  def capture(image_file)
    temp = "/tmp/image_upload#{$$}.png"
    if image_file && File.exist?(image_file)
      system "convert #{image_file} #{temp}"
    else
      system "#{@capture_cmd} #{temp}"
    end

    fail 'No image data' unless File.exist?(temp)
    image_data = File.read(temp)
    File.delete(temp)

    gyazo_url = upload(image_data)

    copy_to_clipboard(gyazo_url)
    open_browser(gyazo_url)
    gyazo_url
  end

  private
  def device_id
    return '' unless File.exist?(@id_file)
    id = File.read(@id_file).chomp
  end

  def save_id(new_id)
    if device_id != ''
      File.rename(@id_file, @id_file+Time.new.strftime("_%Y%m%d%H%M%S.bak"))
    end
    File.open(@id_file,"w") { |f| f.write(new_id) }
  end
end
