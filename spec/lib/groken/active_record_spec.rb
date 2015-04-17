require 'spec_helper'

describe "ActiveRecord mixin" do
  context "after including the mixin in a AR model" do
    let(:user) { User.new }

    before(:all) do
      class User
        include Peel::ActiveRecord
      end
    end

    describe ".generate_token" do
      it "sets the token value on the model" do
        user.generate_token
        expect(user.token).not_to be_nil
      end

      it "returns the token" do
        expect(user.generate_token).to be_a String
      end
    end

    describe ".token?" do
      before do
        @token = user.generate_token
      end

      context "when provided the correct token" do
        it "returns true" do
          expect(user.token?(@token)).to be_truthy
        end
      end

      context "when provide an incorrect token" do
        it "returns false" do
          expect(user.token?('notthetoken')).to be_falsey
        end
      end
    end
  end
end
