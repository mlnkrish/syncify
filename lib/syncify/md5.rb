require 'openssl'
require 'base64'

module Syncify
  class Md5
    @@key = "theanswernevercame"
    @@digest = OpenSSL::Digest::Digest.new('md5')

    def self.hash content
      Base64.encode64(OpenSSL::HMAC.digest(@@digest, @@key , content)).strip
    end

  end


end