require 'fileutils'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'open3'

class Downloader

  def initialize uri, options
    @uri =  URI.parse(uri)
    @folder = options[:folder]
    @retries = options[:retries]
    @has_jpeginfo = jpeginfo_installed
    @retry_corrupt = options[:retry_corrupt]
  end

  def parse
    tries ||= @retries
    @doc = Nokogiri::HTML(open(@uri))
  rescue Exception => e
    puts 'WARNING: ' + e.message
    puts "Parse failed: #{tries-1} tries left"
    sleep 2
    retry unless (tries -= 1).zero?
    return false
  else
    return true
  end

  def iterate
    @doc.css('.fileinfo').each do |info|
      download_url = info.css('a').first.attributes['href'].value
      filename =  info.css('.postfilename').first.children.first.to_s
      download(URI.join(@uri.scheme + '://' +  @uri.host, download_url), filename)
    end
  end

  def download file_url, filename
    tries ||= @retries
    path = File.join(@folder, filename).to_s
    FileUtils.mkdir_p(@folder) unless Dir.exists? @folder
    if @retry_corrupt and File.exists?(path) and file_corrupt?(path)
      FileUtils.rm path
      puts 'Corrupted file removed: ' + path
    end
    if File.exists? path
      puts 'File skipped: ' + File.join(@folder, filename).to_s
    else
      File.open(path, "wb") do |saved_file|
        open(file_url, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end
      puts 'File saved: ' + File.join(@folder, filename).to_s
    end
  rescue Exception => e
    puts 'WARNING: ' + e.message
    puts "Download failed: #{tries-1} tries left"
    sleep 2
    retry unless (tries -= 1).zero?
    puts 'File download failed: ' + path
    FileUtils.rm path
    return false
  else
    return true
  end

  def jpeginfo_installed
    Open3.popen3('jpeginfo --version')
    true
  rescue  Errno::ENOENT
    false
  end

  def file_corrupt? filename
    if File.size(filename) == 0
      return true
    end
    if @has_jpeginfo
      `jpeginfo -c '#{filename}'`
      return ($? != 0)
    end
    false
  end
end
