require 'rails_helper'

RSpec.describe SessionsController, type: :controller do


end

RSpec.feature 'Sessions new' do  #features is usually used for Capybara - it is practically the same as 'Describe'
  before do
    @user = create_user
  end
  scenario 'prompts for email and password' do #scenario is practically the same as 'it'
    visit '/sessions/new'
    expect(page).to have_field('email')
    expect(page).to have_field('password')
  end
  scenario 'logs in user if email/password combination is valid' do
    log_in @user
    expect(current_path).to eq("/users/#{@user.id}")
    expect(page).to have_text(@user.name)
  end
  scenario 'does not sign in user if email/password combination is invalid' do
    log_in @user, 'wrong password'
    expect(page).to have_text('Invalid')
  end
end

RSpec.feature 'Logging Out' do 
 before do 
  @user = create_user
  log_in @user
 end
 scenario 'displays Log Out button when user is logged on' do 
  expect(page).to have_button('Log Out')
 end
 scenario 'logs out user and redirects to login page' do  
 find("input[value='Log Out']").click
  expect(current_path).to eq('/sessions/new')
 end
end
