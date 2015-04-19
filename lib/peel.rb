require 'jwt'
require 'grape'

module Peel
  def self.authenticate_with_token(token)
    begin
      payload = decode_payload(token)
    rescue
      return false
    end
    find_user_by_email(payload['email'])
  end

  def self.find_user_by_email(email)
    User.find_by_email(email)
  end

  def self.encode_payload(payload)
    validate_secret_presence
    JWT.encode(payload, ENV['PEEL_SECRET'])
  end

  def self.decode_payload(jwt_token)
    secret = ENV['PEEL_SECRET']
    JWT.decode(jwt_token, secret)[0]
  end

  def self.validate_secret_presence
    fail 'You must set ENV["PEEL_SECRET"]' unless ENV['PEEL_SECRET']
  end
end

require 'peel/version'
require 'peel/api_include'
require 'peel/api'
