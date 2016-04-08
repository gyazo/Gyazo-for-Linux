require 'net/http'
require 'open3'
require 'openssl'

class GyazoClient

  def initialize(opts = {})
    default_opts = {
      id_file:       ENV['HOME'] + "/.gyazotest.id",
      capture_cmd:   'import',
      browser_cmd:   'xdg-open',
      clipboard_cmd: 'xclip',
      host:          'upload.gyazo.com',
      cgi:           '/upload.cgi',
      ua:            'Gyazo/1.2',
      port:          443,
      use_ssl:       true
    }

    opts = default_opts.merge(opts)

    opts.each do |key, value|
      self.class.class_eval { attr_accessor "#{key}" }
      self.instance_variable_set "@#{key}", value
    end
  end

  def upload(image_data, metadata = nil)
    boundary = '----BOUNDARYBOUNDARY----'

    data = <<EOF
--#{boundary}\r
content-disposition: form-data; name="metadata"\r
\r
#{metadata}\r
--#{boundary}\r
content-disposition: form-data; name="id"\r
\r
#{gyazo_id}\r
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

  private
  def gyazo_id
    return '' unless File.exist?(@id_file)
    id = File.read(@id_file).chomp
  end

  def save_id(new_id)
    if gyazo_id != ''
      File.rename(@id_file, @id_file+Time.new.strftime("_%Y%m%d%H%M%S.bak"))
    end
    File.open(@id_file,"w") { |f| f.write(new_id) }
  end
end
