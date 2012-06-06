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
        return S3.new  conf[:s3_access_key_id],conf[:s3_secret_access_key],conf[:s3_bucket]
      end
    end
  end
end

# #SYNCIFY
# Syncify::Syncify.configure do |config|
#   config[:source][:storage] = "file"
#   config[:source][:location] = ""

#   # config[:dest][:storage] = "file"
#   # config[:dest][:location] = ""

#   config[:dest][:storage] = "s3"
#   config[:dest][:s3_access_key_id] = ""
#   config[:dest][:s3_secret_access_key] = ""
#   config[:dest][:s3_bucket] = ""
# end

# Syncify::Syncify.sync