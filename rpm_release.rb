#!/usr/bin/env ruby
require 'json'
TOKEN = process.env['PACKAGECLOUD_TOKEN']

body = `curl -u #{TOKEN}: https://packagecloud.io/api/v1/distributions.json`
json = JSON.parse(body)

json['rpm'].each do |item|
  os = item['index_name']
  item['versions'].each do |version|
    target = "#{os}/#{version['index_name']}"
    `package_cloud push gyazo/gyazo-for-linux/#{target} /root/rpmbuild/RPMS/x86_64/$PACKAGE-$VERSION-1.x86_64.rpm`
  end
end
