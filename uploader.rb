require 'rest_client'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'

class Uploader
  attr_reader :params, :files

  def initialize uri, options
    @uri =  URI.parse(uri)
    @folder = options[:folder]
    @retries = options[:retries]
    @username = options[:username]
    @password = options[:password]
    @subject = options[:subject]
    @post_url = '/gh/post.php'
    @files = []
    iterate
    @parts = (@files.count + 5) / 6
  end

  def upload
    part = 0
    until @files.empty?
      part += 1
      puts "Part #{part} of #{@parts}"
      puts "To post: #{@files.length} files"
      puts 'Start get'
      get_form
      puts 'Start post'
      post_form part
    end
  end

private

  def get_form
    tries ||= @retries    
    @doc = Nokogiri::HTML(open(@uri), nil,'utf-8', Nokogiri::XML::ParseOptions::NOENT)
    @params = {}
    recursive_form @doc.css('form').first
    clean_params
  rescue Exception => e
    puts 'WARNING: ' + e.message
    puts "Parse failed: #{tries-1} tries left"
    sleep 2
    retry unless (tries -= 1).zero?
  end

  def post_url
    URI.join(@uri.scheme + '://' +  @uri.host, @post_url).to_s
  end

  def random_word
    (0...8).map { (65 + rand(26)).chr }.join
  end
 
  def post_form part
    @params['name'] = @username
    @params['subject'] = @subject
    @params['body'] = "Part #{part} of #{@parts}"
    @params['password'] = @password
    @params['file'] = File.new(@files.shift) unless files.empty?
    @params['file2'] = File.new(@files.shift) unless files.empty?
    @params['file3'] = File.new(@files.shift) unless files.empty?
    @params['file4'] = File.new(@files.shift) unless files.empty?
    @params['file5'] = File.new(@files.shift) unless files.empty?
    @params['file6'] = File.new(@files.shift) unless files.empty?
    begin
      tries ||= @retries    
      response = RestClient.post post_url, @params, headers
    rescue Exception => e
      puts 'WARNING: ' + e.message
      puts "Upload failed: #{tries-1} tries left"
      sleep 10
      retry unless (tries -= 1).zero?
      puts 'File upload failed!'
    end
  end

  def iterate
    Dir.entries(@folder).sort.each do |file|
      next if file == '.' or file == '..'
      next if File.directory? File.join(@folder, file)
      @files << File.join(@folder, file)
    end
  end

  def headers
    { 
      user_agent: 'Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20100101 Firefox/35.0', 
      referer: @uri.to_s
     }
  end

  def clean_params
    @params.delete 'file' 
    @params.delete 'file2' 
    @params.delete 'file3' 
    @params.delete 'file4' 
    @params.delete 'file5' 
    @params.delete 'file6'
  end

  def recursive_form element
    if element.name =~ /input/ and  element.attributes['name']
      @params[element.attributes['name'].value] = element.attributes['value'] ? element.attributes['value'].value : nil
    end
    if element.name =~ /textarea/
      @params[element.attributes['name'].value] = element.children.first ? element.children.first.text : nil
    end
    element.children.each do |c|
     recursive_form c
    end
  end
end
