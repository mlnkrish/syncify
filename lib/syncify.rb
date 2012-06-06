require "syncify/version"
require "syncify/file_store"
require "syncify/s3"
require "syncify/synchronizer"

module Syncify
  class Syncify
    @@configuration = {:source => {}, :dest => {}}
    
    def self.configure
      yield @@configuration
    end

    def self.sync
      puts @@configuration
      source = init @@configuration[:source]
      dest = init @@configuration[:dest]

      puts "source -> #{source.to_s}"
      puts "dest -> #{dest.to_s}"

      synchronizer = Synchronizer.new source, dest
      synchronizer.synchronize
    end

    def self.init conf
      if(conf[:storage] == "file")
        return FileStore.new conf[:location]
      end
      if(conf[:storage] == "s3")
        return S3.new 
      end
    end
  end
end