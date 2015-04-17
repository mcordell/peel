require 'spec_helper'

describe Peel::API do
  describe "accessing an endpoint on the Peel API" do
    context "when not passing an authentication token" do
      it "response is a 401" do
        get '/protected'
        expect(response.status).to be 401
      end
    end

    context "when passing a valid auth token in the Authorization header" do
      let(:user) { create_user('test@example.com') }
      let(:token) { user.generate_token }
      let(:valid_token) { Peel.encode_payload({'email' => 'test@example.com', 'token' => token})}

      before(:all) do
        class User
          include Peel::ActiveRecord
        end
      end

      after { user.delete }

      it "responds 200" do
        get '/protected', { 'Authorization' => valid_token }
        expect(response.status).to be 200
      end

      it "gets the protected content" do
        get '/protected', { 'Authorization' => valid_token }
        expect(response.body).to eq({'were' => 'in'}.to_json)
      end
    end
  end
end
