require 'spec_helper'

describe Peel do
  let(:valid_payload) { {email: 'some', token: 'sometoken'} }
  describe ".find_user_by_email" do
    context "when given a user that exists in the Acitve Record connected database" do
      let(:email) { 'test@example.com' }
      before do
        @user = User.create(email: email)
      end

      after { @user.delete }

      it "returns the user" do
        expect(Peel.find_user_by_email(email)).to eq @user
      end
    end
  end

  describe ".validate_secret_presence" do
    context "when ENV['PEEL_SECRET'] is nil" do
      before do
        @old = ENV['PEEL_SECRET']
        ENV['PEEL_SECRET'] = nil
      end

      after { ENV['PEEL_SECRET'] = @old }

      it "raises an error" do
        expect { Peel.validate_secret_presence }.to raise_error('You must set ENV["PEEL_SECRET"]')
      end
    end
  end

  describe ".decode_payload" do
    let(:secret) { 'secret' }
    let(:payload) { {'email' => 'test@example.com'} }
    let(:jwt_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20ifQ.3QJBsXLwBNSyLWLDA5nugTzc83x9Ac9zsxKkghKJ__E' }

    before do
      @old_secret = ENV['PEEL_SECRET']
      ENV['PEEL_SECRET'] = secret
    end

    after { ENV['PEEL_SECRET'] = @old_secret}

    context "when given a valid token" do
      it "returns the payload" do
        expect(Peel.decode_payload(jwt_token)).to eq payload
      end
    end

    context "when given a token payload that has been tampered with" do
      it "raises an error" do
        tampered_payload = payload.clone
        tampered_payload['token'] = 'tokens wrong bro'
        tampered_token = JWT.encode(tampered_payload, 'key is wrong')
        expect{Peel.decode_payload(tampered_token)}.to raise_error
      end
    end

    context "when given a valid token, that has expired" do
      it "raises an error" do
        payload['exp'] = Time.now.to_i() - 400
        expired_token = JWT.encode(payload, secret)
        expect{ Peel.decode_payload(expired_token) }.to raise_error
      end
    end

    context "when given an empty string" do
      it "raises an error" do
        expect{Peel.decode_payload('')}.to raise_error
      end
    end

    context "when given an invalid string" do
      it "raises an error" do
        expect{Peel.decode_payload('lalalalaal')}.to raise_error
      end
    end
  end

  describe ".encode_payload" do
    context "when secret is not set" do
      before do
        @old = ENV['PEEL_SECRET']
        ENV['PEEL_SECRET'] = nil
      end

      after { ENV['PEEL_SECRET'] = @old }

      it "raises an error" do
        expect { Peel.encode_payload(valid_payload) }.to raise_error('You must set ENV["PEEL_SECRET"]')
      end
    end

    context "when payload is valid" do
      it "returns a json web token string" do
        expect(Peel.encode_payload(valid_payload)).to be_a String
      end
    end

    context "when passed payload is nil" do
      it "raises an error" do
        expect { Peel.encode_payload(nil) }.to raise_error
      end
    end
  end

  describe ".authenticate_with_token" do
    let(:email) { 'test@example.com' }
    let(:payload) { { 'email' => email } }

    before do
      @user = User.create(email: email)
      @old = ENV['PEEL_SECRET']
      ENV['PEEL_SECRET'] = 'secret'
      @jwt_token = Peel.encode_payload(payload)
    end

    after do
      @user.delete
      ENV['PEEL_SECRET'] = @old
    end

    context "when passed a bad token" do
      it "returns false" do
        expect(Peel.authenticate_with_token('thistoken.is.bad')).to be_falsey
      end
    end

    context "when passed a token that contains an email not belonging to a user" do
      let(:bad_email_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNvbWV0aGluZ0Bzb21lb25lLmNvbSJ9.pLbGZ3WMPUmETbtTTjF3Su6UgN1XF5dzvkWgmL6Z1-s' }

      it "returns false" do
        expect(Peel.authenticate_with_token(bad_email_token)).to be_falsey
      end
    end
  end
end
