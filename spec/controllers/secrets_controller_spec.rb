require 'rails_helper'

RSpec.describe SecretsController, type: :controller do
  before do 
    @user = create_user
    @secret = @user.secrets.create(content: 'secret')
  end 
  describe 'when not logged in' do 
    before do 
      session[:user_id] = nil
    end
    it 'cannot access index' do 
      get :index
      expect(response).to redirect_to('/sessions/new')
    end
    it 'cannot access create' do 
      get :create 
      expect(response).to redirect_to('/sessions/new')
    end
    it 'cannot access destroy' do 
      delete :destroy, id: @secret 
      expect(response).to redirect_to('/sessions/new')
    end
  end
  describe 'when logged in as the wrong user' do 
    before do 
      @wrong_user = create_user 'julius', 'julius@lakers.com'
      session[:user_id] = @wrong_user.id
      @secret = @user.secrets.create(content: 'OH YEAH')
    end
    it 'cannot access destroy' do 
      delete :destroy, id: @secret, user_id: @user 
      expect(response).to redirect_to("/users/#{@wrong_user.id}")
    end
  end
end

RSpec.feature 'user profile page' do 
  before do 
    @user = create_user
    log_in @user
  end
  scenario 'displays a user\'s secrets on profile page' do 
    secret = @user.secrets.create(content: 'secret')
    visit "/users/#{@user.id}"
    expect(page).to have_text("#{secret.content}")
  end
  scenario 'displays everyone\'s secrets' do 
    user2 = create_user 'julius', 'julius@lakers.com'
    secret1 = @user.secrets.create(content: 'secret')
    secret2 = @user.secrets.create(content: 'secret')
    visit '/secrets'
    expect(page).to have_text(secret1.content)
    expect(page).to have_text(secret2.content)
  end
end

RSpec.feature 'new secret' do 
  scenario 'provides form in user profile page to create a new secret' do 
    user = create_user
    log_in user
    expect(page).to have_field('New Secret')
  end
end

RSpec.feature 'creating a secret' do 
  scenario 'creates a new secret and redirects to profile page' do 
    user = create_user
    log_in user
    fill_in 'New Secret', with: 'My Secret'
    find("input[value='Create Secret']").click
    expect(current_path).to eq("/users/#{user.id}")
    expect(page).to have_text('My Secret')
  end
end

RSpec.feature 'deleting a secret' do 
  before do 
    @user = create_user
    log_in @user 
    fill_in 'New Secret', with: 'My Secret'
    find("input[value='Create Secret']").click
    expect(page).to have_text('My Secret')
  end
  scenario 'deletes secrets from profile page and redirects to profile page' do
    find("input[value='Delete']").click
    expect(current_path).to eq("/users/#{@user.id}")
    expect(page).not_to have_text('My Secret')
  end
  scenario 'deletes secret from secrets index page and redirects to current user profile page' do
    visit '/secrets'
    find("input[value='Delete']").click
    expect(current_path).to eq("/users/#{@user.id}")
    expect(page).not_to have_text('My Secret')
  end
end

