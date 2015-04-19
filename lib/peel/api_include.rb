require 'warden'

module Peel
  module ApiInclude
    def self.included(base)
      Peel.validate_secret_presence

      base.use Warden::Manager do |manager|
        manager.default_strategies :token
        manager.failure_app = lambda do |env|
          [401, {}, [{ error: 'Not authorized' }.to_json]]
        end
      end

      base.helpers do
        def warden
          env['warden']
        end
      end

      Warden::Strategies.add(:token) do
        def valid?
          request.env['HTTP_AUTHORIZATION'].present?
        end

        def authenticate!
          token = request.env['HTTP_AUTHORIZATION']
          user = Peel.authenticate_with_token(token)
          user.nil?  ? fail!('Unauthorized') : success!(user)
        end
      end
    end
  end
end
