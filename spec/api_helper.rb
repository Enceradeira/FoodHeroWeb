require 'rack/test'
require 'rails'

module ApiHelper
  def json
    @json ||= JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
end