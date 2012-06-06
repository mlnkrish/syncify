require 'syncify/md5'
require 'fileutils'

module Syncify
  
  class FileStore
    
    def initialize location
      @location = location
    end

    def all_md5
      all_md5s = {}
      Dir.glob(@location+"**/*.*") do |file| 
        # puts file
        relative_path = file.split(@location)[1] 
        contents = IO.read file
        hash = Md5.hash contents
        all_md5s[relative_path] = hash 
        # puts hash
      end
      all_md5s
    end

    def get_path name
      @location+name
    end

    def add name,path
      full_path = @location+name
      FileUtils.mkdir_p(File.dirname(full_path))
      FileUtils.cp(path, full_path)
    end

    def modify name,path
      add name,path
    end

    def delete name
      FileUtils.rm @location+name
    end

    def cached_md5
      cache_file = @location+"syncify_cache.txt"
      return nil unless File.exists? cache_file
      contents = IO.read(cache_file)
      cached_md5s = {}
      contents.split("\n").each do |line|
        split = line.split("|")
        cached_md5s[split[0]] = split[1]
      end
      cached_md5s
    end

    def write_cache hash
      File.open(@location+"syncify_cache.txt", "w") do |f|
        hash.each {|k,v| f.write "#{k}|#{v}\n"}
      end
    end

    def to_s
      "File -> #{@location}"
    end
  end

end