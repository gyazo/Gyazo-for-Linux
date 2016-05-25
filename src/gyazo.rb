#!/usr/bin/env ruby
require 'yaml'
require_relative 'gyazo_client'

# setting
config_file = "#{ENV['HOME']}/.gyazo.config.yml"
opts = {}
opts = YAML.load_file(config_file) if File.exist?(config_file)

gyazo_client = GyazoClient.new(opts)

gyazo_url = gyazo_client.capture(ARGV[0])

puts gyazo_url
