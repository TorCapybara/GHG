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

Just clone repository and it should be ready to run, please run it locally "./GHG.rb" it is not tested for a global installation.

    git clone https://github.com/TorCapybara/GHG.git


Run GHG
-------

Help for runninng

    ./GHG.rb -h

Grab images

    ./GHG.rb http://domain.tld/thread/1.html -f folder 

Update with corruption check

    ./GHG.rb http://domain.tld/thread/1.html -cf folder


Versions
-------

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

