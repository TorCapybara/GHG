#!/usr/bin/env ruby
require_relative 'downloader'
require 'optparse' 
require 'pp'

version = 'v1.0'

options = {}

optparse = OptionParser.new do|opts| 
  # assumed to have this option. 
  opts.separator 'GHGrabber ' + version
  opts.separator ''
  opts.on( '-f [FOLDER]', '--folder [FOLDER]', 'save images to this folder (mandatory)' ) do |folder|
    options[:folder] = folder
  end 
  opts.on( '-h', '--help', 'Display this screen' ) do 
    puts opts.help();
    exit 0 
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

dl = Downloader.new ARGV.first, options[:folder]
dl.parse
dl.iterate

