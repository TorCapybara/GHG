#!/usr/bin/env ruby
require_relative 'downloader'
require 'optparse' 
require 'yaml'

version = 'v1.6'

# Load config files
config_file, config = File.expand_path('../config.yml', __FILE__), {}
config = YAML.load_file(config_file) if File.exists?(config_file)

# Configuration can Override options
options = { retries: 5, retry_corrupt: false, use_proxy: false }.merge(config)

# Command Line Parameters
optparse = OptionParser.new do|opts| 
  opts.separator 'GHGrabber ' + version
  opts.separator ''
  opts.on( '-f [FOLDER]', '--folder [FOLDER]', 'save images to this folder (mandatory)' ) do |folder|
    options[:folder] = folder
  end 
  opts.on( '-c', '--corruption-check', 'Checks if files are corrupted from last run and retries those files' ) do
    options[:retry_corrupt] = true
  end 
  opts.on( '-h', '--help', 'Display this screen' ) do 
    puts opts.help();
    exit 0 
  end 
  opts.on( '-r [NUMBER]', '--retries [NUMER]', 'Retry n times if download failed. Default: 5' ) do |retries|
    options[:retries] = retries.to_i
  end 
  opts.on( '-v', '--version', 'Version' ) do 
    puts 'GHGgrabber - version ' + version + ' by Capybara (2015)'
    exit 0 
  end 

  opts.separator ''
  opts.separator 'Examlpe:'
  opts.separator '  GHG.rb http://dom.onion/gh/some/res/1.html -f name'
  opts.separator ''
  opts.separator 'Source:'
  opts.separator '  https://github.com/TorCapybara/GHG'
  opts.separator ''
end


if ARGV.count == 0
  puts optparse.summarize
  exit 0
end

optparse.parse!

if ARGV.count > 1
  puts 'You need exaxtly one URL to download'
  exit 1
end

unless ARGV.first =~ /^http:/
  puts 'Cannot grab: You must provide a fully qualified URL: http://domain.tld/path/some.html'
  exit 1
end

unless options[:folder]
  puts 'Cannot grab: Folder (-f folder) is mandatory'
  exit 1
end

if options[:use_proxy]
  require 'socksify'
  TCPSocket::socks_server = options[:proxy][:server]
  TCPSocket::socks_port = options[:proxy][:port]
end

dl = Downloader.new ARGV.first, options
if dl.parse
  dl.iterate
else
  puts 'Cannot grab: Cannot parse document. (Network problem? Invalid URL? Wrong Proxy Settings?)'
  exit 1
end

