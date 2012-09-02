#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# ddns.rb
# DDnS client for ddo.jp/ieserver.net

require 'json'
require 'open-uri'
require 'time'

IP_SERVER = 'http://u.w5n.org/ip'
PERIODICAL_UPDATE_SECOND = 6 * 24 * 60 * 60 # 6 days
RANDOM_WAIT_SECOND = 600

def GetWorkDir()
    # directory where this script exists
    f = File.expand_path(__FILE__)
    d = File.dirname(f)    
    return d + "/"
end

def GetConfigFile()
    return GetWorkDir() + "config.json"
end

def GetPrevIPFile()
    return GetWorkDir() + "ip.txt"
end

def GetCurrentIP()
    return open(IP_SERVER).read()
end

def Update(debug = false)
    update = false

    if(!debug) then
        # randomize access to avoid server congestion
        Random.srand()
        sleep(rand(RANDOM_WAIT_SECOND) + 1)
    end

    # get previous ip
    prev_ip = ""
    prev_update = Time.now()
    prev_file = GetPrevIPFile()

    if(File.exist?(prev_file)) then
        open(prev_file,'r') do |fp|
            prev_ip = fp.read().chomp()
        end
        prev_update = File.ctime(prev_file)
    else
        # first time
        update = true
    end

    # get current ip
    current_ip = GetCurrentIP().chomp()
    
    if(prev_ip != current_ip) then
        # ip changed
        update = true
    elsif(Time.now() - prev_update > PERIODICAL_UPDATE_SECOND) then
        # periodical update for maintaining account
        update = true
    end

    return if !update

    # update ddns
    conf = JSON.parse(open(GetConfigFile()).read())
    conf["url"].each do |url|
        r = open(url).read()
        puts r if debug
    end

    # save current ip
    open(prev_file,'w') do |fp|
        fp.write(current_ip)
    end
end

def main(argv)
    debug = false
    if(argv.size == 1 && argv[0] == "-d") then
        debug = true
    end
    
    Update(debug)
end

if __FILE__ == $0 then
    main(ARGV)
end
