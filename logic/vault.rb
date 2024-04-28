require 'securerandom'
require 'digest'
require 'base64'
require 'openssl'

TYPE = OpenSSL::Cipher::AES256.new(:CBC)
$VAULT = File.join(__dir__, '../', 'house.dat')

def session; OpenSSL::Digest.digest('sha256', SecureRandom.hex(16)) end

def encrypt(data, key, c = TYPE)
  c.encrypt
  c.key = key
  IO.write($VAULT, Base64.strict_encode64( c.update(data) + c.final ))
end

def decrypt(data, key, dc = TYPE)
  dc.decrypt
  dc.key = key
  dc.update(Base64.strict_decode64(data)) + dc.final
end


