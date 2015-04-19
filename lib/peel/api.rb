module Peel
  class API < Grape::API
    def self.inherited(base)
      base.include(Peel::ApiInclude)
      base.before do
        warden.authenticate!
      end
      super
    end
  end
end
