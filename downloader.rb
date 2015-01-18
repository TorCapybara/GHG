require 'nokogiri'
require 'open-uri'
require 'uri'

class Downloader

  def initialize uri, folder
    @uri =  URI.parse(uri)
    @folder = folder
  end

  def parse
    @doc = Nokogiri::HTML(open(@uri))
  end

  def iterate
    @doc.css('.fileinfo').each do |info|
      download_url = info.css('a').first.attributes['href'].value
      filename =  info.css('.postfilename').first.children.first.to_s
      download(URI.join(@uri.scheme + '://' +  @uri.host, download_url), filename)
    end
  end


  def download file_url, filename
    Dir.mkdir(@folder) unless Dir.exists? @folder
    if File.exists? File.join(@folder, filename)
      puts 'File skipped: ' + File.join(@folder, filename).to_s
    else
      File.open(File.join(@folder, filename), "wb") do |saved_file|
        open(file_url, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end
      puts 'File saved: ' + File.join(@folder, filename).to_s
    end
  end
end
