GHGrabber
=========

Grabs Images from GH Forum.

Downloads Images with correct filenames from a  Tinyboard + vichan


Prepare on Linux
----------------

Install a recent ruby

    apt-get install ruby


install the nokogiri gem

    gem install nokogiri

if you run no transparent proxy you need to install the socksify gem too (Not needed for Tails or Whonix)

    gem install socksify

If you want to upload you will also need to install the rest-client gem (OPTIONAL, only needed for posting/upload)

    gem install rest-client 

To have a better jpeg corruption check install jpeginfo (OPTIONAL)

    apt-get install jpeginfo


Prepare on Tails
----------------

### install packages via Synaptic Package Manager 

1. ruby 
* ruby-nokogiri 
* ruby1.9.1 (for compatibility) 
* check is "libruby1.9.1" also marked for install

### To be sure your TAILS will start with ruby after reboot set ruby as additional-software 

1. start nautilus as root 
* go to /live/persistent/TailsData_unlocked/ 
* open in gedit "live-additional-software.conf" 
* write per line: 

```
    ruby 
    ruby1.9.1 
    ruby-nokogiri 
```

* save the file 
* now you have done and it should work.


Install instructions
--------------------

Download the zip file and decompress it or clone the repository and it should be ready to run.

    https://github.com/TorCapybara/GHG/archive/master.zip

Edit the config file if necessary.

    nano config.yml

* For Tor Browser Bundle: works as is
* As a standard Tor installation: Change port to 9050
* For Transparent Proxy (Tails, Whonix): use_proxy: false
* For upload, you can configure username and password permanently.


Run GHG
-------

Help for runninng

    ./GHG.rb -h

Grab images

    ./GHG.rb http://domain.tld/thread/1.html -f folder 

Update with corruption check

    ./GHG.rb http://domain.tld/thread/1.html -cf folder

Upload folder of images

    ./GHG.rb http://domain.tld/thread/1.html -u "Image Set" -n username -p password -f folder

Operating Systems
-----------------

Should work on any platform supported by Ruby, and was sucessfully tested on:
Windows, Linux (Whonix, Tails, Ubuntu, Debian)

Versions
-------

2.0
* GHGrabber has been extended to be a batch uploader too.

1.6
* Try to convert html-entities correctly: filenames like "some &amp; other" will be converted to "some & other"

1.5
* Fix for Ruby 1.9.3 and before, and fix abort on Socks errors

1.4
* Supports Tor without a Transparent Proxy (Added config file with proxy settings)

1.3
* Remove files if download failed (empty file proble)
* Udate files which are corrupt (Option -c)
* Better instructions

1.2
* Support subfolders (folder/subfolder)

1.1
* Handle connection problems better (Retry option)

1.0
* Basic script with instructions

