require 'krn/auth/version'
require 'jwt'
require 'base64'
require 'openssl'
require 'net/http'
require 'http_signatures'

module Krn
  # KRN Auth Class
  class Auth
    attr_accessor :name, :crypt_key, :hmac_secret, :rest_key, :rsa_key

    # Your code goes here...
    def initialize(opts)
      @name = opts[:name]
      @crypt_key = opts[:crypt_key]
      @hmac_secret = opts[:hmac_secret]
      @rest_key = opts[:rest_key]
      @rsa_key  = opts[:rsa_key]
    end

    def validate(passport: '')
      token_parts = passport.split(':')
      raise 'Validation Failed' if token_parts.first != @name

      begin
        decoded_token = JWT.decode token_parts.last, @hmac_secret
        decrypt(decoded_token.first['payload'])
      rescue StandardError => e
        false
      end
    end

    def deep_validate(passport: '')
      uri = URI("#{trinity_url}/deep-validate?token=#{passport}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      res = http.request(req)
      JSON.parse(res.body)
    rescue StandardError
      false
    end

    def send_request(method: '', path: '', headers: [], body: '')
      uri = URI("#{trinity_url}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = false
      m = Net::HTTP::Post
      m = Net::HTTP::Get if method == 'GET'
      req = m.new(uri.path, 'Content-Type' => 'application/json')

      req['KRN-PARTNER-KEY'] = @rest_key
      req['Date'] = Time.now.getutc
      req['KRN-SIGN-URL'] = uri

      req.body = body

      req = sign_request(req)
      req['Authorization'] = nil

      res = http.request(req)
      JSON.parse(res.body)
    rescue StandardError => e
      false
    end

    def sign_request(req)
      $context = HttpSignatures::Context.new(
        keys: { 'KMM_KEY' => {
          private_key: @rsa_key
        } },
        headers: %w[KRN-SIGN-URL KRN-PARTNER-KEY Date],
        algorithm: 'rsa-sha256'
      )
      $context.signer.sign(req)

      req
    end

    def decrypt(data)
      secretdata = Base64.decode64(data)
      decipher = OpenSSL::Cipher.new('aes-256-cbc')
      iv = 'x' * decipher.iv_len
      decipher.decrypt
      decipher.key = @crypt_key
      f = decipher.update(secretdata) + decipher.final
      f = f[decipher.iv_len..-1]
      JSON.parse(f)
    end

    def trinity_url
      ENV['KRN_HOST_PREFIX'] ? 'http://' + ENV['KRN_HOST_PREFIX'] + 'trinity.krn.krone.at' : 'https://trinity.krone.at'
    end
  end
end
