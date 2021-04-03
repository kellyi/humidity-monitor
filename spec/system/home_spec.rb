require 'rails_helper'

RSpec.describe 'home_page' do
  let(:home_page) { HomePage.new }

  before do
    WebMock.disable_net_connect!(allow: '127.0.0.1')
  end

  let!(:older_reading) { FactoryBot.create(:environment_reading, created_at: Time.zone.now - 1.day, temperature: 40) }
  let!(:newer_reading) { FactoryBot.create(:environment_reading, created_at: Time.zone.now, temperature: 80) }

  scenario 'the user can visit the homepage' do
    visit '/'
    expect(home_page).to be_loaded
    expect(home_page).to have_humidity_monitor_nav_link
    expect(home_page).to have_environment_readings_table
    expect(home_page.environment_reading_row.first).to have_content '80.0'
    expect(home_page.environment_reading_row.last).to have_content '40.0'
  end
end
