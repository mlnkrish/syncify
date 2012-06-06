module Syncify

  class S3
    def initialize access_key_id, secret_access_key,bucket
      @access_key_id = access_key_id
      @secret_access_key = secret_access_key
      @bucket = bucket
    end

    def to_s
      "S3 -> #{@bucket}"
    end
  end

end