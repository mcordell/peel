require 'jwt'
require 'securerandom'
require 'grape'
require 'bcrypt'

module Peel
  def self.authenticate_with_token(token)
    begin
      payload = decode_payload(token)
    rescue
      return false
    end
    user = find_user_by_email(payload['email'])
    is_authorized = (user && test_token(user.token, payload['token']))
    is_authorized ? user : false
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

  def self.generate_token(length = 16)
    SecureRandom.hex(length)
  end

  def self.encrypt_token(token)
    BCrypt::Password.create(token)
  end

  def self.test_token(encrypted_token, test_token)
    BCrypt::Password.new(encrypted_token) == test_token
  end
end

require 'peel/version'
require 'peel/api_include'
require 'peel/api'
require 'peel/active_record_include'
