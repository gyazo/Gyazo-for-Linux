require "./src/gyazo_client"
require "test/unit"

class TestGyazoClient < Test::Unit::TestCase
  def setup
    @gyazo_client = GyazoClient.new(id_file: "./.gyazo_id_test")
  end

  def teardown
    Dir.glob('./.gyazo_id_test*').each { |f| File.delete(f) }
  end

  def test_instance_variables
    assert_equal('import', @gyazo_client.capture_cmd)

    excess_client = GyazoClient.new(capture_cmd: 'scrot -s', foo: 'bar')
    assert_equal('scrot -s', excess_client.capture_cmd)
    assert_equal(443, excess_client.port)
    assert_equal('bar', excess_client.foo)
  end

  def test_gyazo_id
    assert_equal('', @gyazo_client.send(:gyazo_id))

    File.open(@gyazo_client.id_file, 'w') {|f| f.write('-ninja-') }
    assert_equal('-ninja-', @gyazo_client.send(:gyazo_id))
  end

  def test_save_id
    @gyazo_client.send(:save_id, '-bushi-')
    assert_equal('-bushi-', File.read(@gyazo_client.id_file).chomp)

    @gyazo_client.send(:save_id, '-ronin-')
    assert_equal('-ronin-', File.read(@gyazo_client.id_file).chomp)
    assert(!Dir.glob('./.gyazo_id_test_*.bak').empty?)
  end

  def test_upload
    image_data = File.read('./test/images/ninja.png')
    assert_match(/https:\/\/gyazo\.com\/[0-9a-f]{32}/, @gyazo_client.upload(image_data))
  end
end
