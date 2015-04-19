require 'spec_helper'

describe Peel::ApiInclude do
  context "when included in a class" do
    it "provides a warden helper" do
      expect(Test::API.helpers.instance_methods).to include(:warden)
    end
  end
end
