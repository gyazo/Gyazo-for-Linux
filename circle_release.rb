#!/usr/bin/env ruby
require 'json'
TOKEN = process.env['PACKAGECLOUD_TOKEN']

body = `curl -u #{TOKEN}: https://packagecloud.io/api/v1/distributions.json`
json = JSON.parse(body)

json['deb'].each do |item|
  os = item['index_name']
  item['versions'].each do |version|
    target = "#{os}/#{version['index_name']}"
    `package_cloud push gyazo/gyazo-for-linux/#{target} ../gyazo*all.deb || true`
  end
end
