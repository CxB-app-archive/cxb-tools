# coding: utf-8

require "pp"
require "fileutils"
require "net/http"

APP_BASE_DIR = "64_06_4B66B35C"
BASE_URL = "https://cxb-dl.ac.capcom.jp"
STATIC_FILES = %w|
  config/config_11600.json
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
  File.join("resource", path)
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

File.readlines("download_file_list.txt").each do |e|
  file = File.join(APP_BASE_DIR, e.chomp)
  FileUtils.mkdir_p(File.dirname(dst_path(file)))
  download(file) unless File.exist?(dst_path(file))
end
