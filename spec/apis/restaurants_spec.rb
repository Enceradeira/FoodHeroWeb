require_relative '../../spec/rails_helper'

describe 'Restaurants API' , type: :api do

  it 'should return 7' do

    get '/api/v1/restaurants'

    expect(response).to be_success            # test for the 200 status-code
    expect(json['messages'].length).to eq(7) # check to make sure the right amount of
    expect(json['content']).to eq(message.content)
  end
end