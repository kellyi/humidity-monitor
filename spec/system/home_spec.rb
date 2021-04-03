require 'rails_helper'

RSpec.describe 'home_page' do
  let(:home_page) { HomePage.new }

  scenario 'the user can visit the homepage' do
    visit '/'
    expect(home_page).to be_loaded
  end
end
