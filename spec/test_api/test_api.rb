require 'grape'

module Test
  class ProtectedAPI < Peel::API
    get '/protected' do
      {'were' => 'in'}.to_json
    end
  end

  class API < Grape::API
    include Peel::ApiInclude
    mount Test::ProtectedAPI
    get '/' do
      {}
    end
  end
end
