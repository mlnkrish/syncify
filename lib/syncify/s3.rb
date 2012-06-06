require 'fog'

module Syncify

  class S3
    def initialize access_key_id, secret_access_key,bucket
      @access_key_id = access_key_id
      @secret_access_key = secret_access_key
      @bucket = bucket
      @connection = Fog::Storage.new({
                                      :provider                 => 'AWS',
                                      :aws_access_key_id        => access_key_id,
                                      :aws_secret_access_key    => secret_access_key
                                    })
    end

    def all_md5
      # not needed for now
    end

    def get_content name
      content = @connection.get_object(@bucket, name).body
    end

    def add name,content
      content_type = "text/plain"
      content_type = "image/jpeg" if name.end_with? "jpg"
      content_type = "image/png" if name.end_with? "png"
      @connection.put_object(@bucket, name ,content, 'Content-Type' => content_type)
    end

    def modify name,content
      add name, content
    end

    def delete name
      begin
        @connection.delete_object @bucket, name  
      rescue Exception => e
        unless e.response.status = 404
          raise e
        end
      end
    end

    def cached_md5
      begin
        cache_data = @connection.get_object @bucket, "syncify_cache.txt"  
      rescue Exception => e
        if e.response.status = 404
          puts "S3 : error fecthing cache data 404"
          return nil
        end
        raise e
      end
      contents = cache_data.body
      cached_md5s = {}
      contents.split("\n").each do |line|
        split = line.split("|")
        cached_md5s[split[0]] = split[1]
      end
      cached_md5s
    end

    def write_cache hash
      content = ""
      hash.each do |k,v|
        content += "#{k}|#{v}\n"
      end
      
      @connection.put_object(@bucket,"syncify_cache.txt",content, 'Content-Type' => "text/plain")
    end

    def to_s
      "S3 -> #{@bucket}"
    end
  end

end