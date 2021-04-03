require 'rails_helper'

RSpec.describe 'home_page' do
  let(:home_page) { HomePage.new }

  before do
    WebMock.disable_net_connect!(allow: '127.0.0.1')
  end

  scenario 'the user can visit the homepage' do
    visit '/'
    expect(home_page).to be_loaded
  end
end
