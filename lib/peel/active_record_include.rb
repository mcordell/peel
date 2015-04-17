module Peel
  module ActiveRecord
    def generate_token
      new_token = Peel.generate_token
      update_attribute(:token, Peel.encrypt_token(new_token))
      new_token
    end

    def token?(test_token)
      Peel.test_token(token, test_token)
    end
  end
end
