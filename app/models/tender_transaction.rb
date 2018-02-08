class TenderTransaction < ApplicationRecord

  SECRET_KEY = 'c610c0b75f1711a1c392c6a5d823390ee31e8c0ba40b9f2778570b249fa2c958'.freeze

  CLIENT_KEY = '8e10dd4fd8bf4dc6efc76a4560d7b77a216ae4a9'.freeze

  URL = 'https://korbaxchange.herokuapp.com/api/v1.0/collect/'.freeze

  CALLBACK_URL = 'https://buildpals-development.herokuapp.com/tender/transactions/complete_transaction/'.freeze

  CLIENT_ID = 15.freeze

  enum status: {
      pending: 0,
      success: 1,
      failed: 2
  }

  belongs_to :participant

  belongs_to :request_for_tender

  def self.secret_key
    SECRET_KEY
  end

  def self.url
    URL
  end

  def self.call_back_url
    CALLBACK_URL
  end

  def self.client_id
    CLIENT_ID
  end

  def self.description
    'Payment of Tender'
  end

  def self.make_digest(secret_key, message)
    OpenSSL::HMAC.hexdigest('SHA256', secret_key, message)
  end

  def self.get_json_representation(hash_params)
    JSON.generate(hash_params)
  end

  def self.get_ruby_representation(json)
    JSON.parse(json)
  end

  def self.create_message(ruby_hash)
    message = ''
    n = 0
    ruby_hash.each do |k, v|
      if n.zero?
        message = message + k.to_s + '=' + v.to_s
      else
        message = message + '&' + k.to_s + '=' + v.to_s
      end
      n += 1
    end
    message
  end

  def self.auth_signature(message)
    digest = make_digest(SECRET_KEY, message)
    authorization = "HMAC #{CLIENT_KEY}:#{digest}"
    authorization
  end

  def self.make_payment(authorization, payload, params)
    uri = URI.parse(self.url)
    if Rails.env.production?
      proxy_address = ENV["QUOTAGUARDSTATIC_URL"]
      https = Net::HTTP.new(uri.host, uri.port, proxy_address)
    else
      https = Net::HTTP.new(uri.host, uri.port)
    end
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, nil, )
    req['Content-Type'] = 'application/json'
    req['Authorization'] = authorization
    req.body = JSON.generate(payload)
    res = https.request(req)
    url_hash = res.body.split(',')[1]
    url = url_hash.split('"').last
    #puts "Response #{res.code} #{res.message}: #{res.body}}"
    if res.code.eql?('200')
        tender_transaction = TenderTransaction.new(params)
        tender_transaction.save!
        return url
    end
  end

end
