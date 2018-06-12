# coding: utf-8

require "pp"
require "fileutils"
require "net/http"

APP_BASE_DIR = "64_06_4B66B35C"
BASE_URL = "https://cxb-dl.ac.capcom.jp"
STATIC_FILES = %w|
  config/config_10101.json
  config/config_10301.json
  config/config_10400.json
  config/config_10401.json
  config/config_10500.json
  config/config_10600.json
  config/config_10700.json
  config/config_10800.json
  config/config_10801.json
  config/config_10803.json
  config/config_10900.json
  config/config_10901.json
  config/config_10902.json
  config/config_11000.json
  config/config_11001.json
  config/config_11100.json
  config/config_11200.json
  config/config_11201.json
  config/config_11300.json
  config/config_11400.json
  config/config_11503.json
|

class Https
  def self.get(url)
    uri = URI(url)

    req = Net::HTTP::Get.new(uri, {
      "Accept" => "*/*",
      "User-Agent" => "",
      "Accept-Language" => "ja-jp",
      "Accept-Encoding" => "gzip, deflate",
    })

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.proxy_from_env = true

    res = https.start do |http|
      http.request(req)
    end

    if res.code == "200"
      res.body
    else
      res.value
    end
  end
end

def dst_path(path)
  File.join("resource_extra", path)
end

def download(path)
  url = "#{BASE_URL}/#{path}"
  puts url

  File.binwrite(dst_path(path), Https.get(url))
end

STATIC_FILES.each do |file|
  FileUtils.mkdir_p(File.dirname(dst_path(file)))
  download(file) unless File.exist?(dst_path(file))
end

File.readlines("download_file_list_extra.txt").each do |e|
  file = e.chomp
  FileUtils.mkdir_p(File.dirname(dst_path(file)))
  download(file) unless File.exist?(dst_path(file))
end
