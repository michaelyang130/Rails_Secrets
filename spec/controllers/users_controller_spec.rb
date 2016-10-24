require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	before do 
		@user = create_user
	end
	describe 'when not logged in' do 
		before do 
			session[:user_id] = nil
		end
		it 'cannot access show' do 
			get :show, id: @user 
			expect(response).to redirect_to('/sessions/new')
		end
		it 'cannot access edit' do 
			get :edit, id: @user
			expect(response).to redirect_to('/sessions/new')
		end
		it 'cannot access update' do 
			put :update, id: @user
			expect(response).to redirect_to('/sessions/new')
		end
		it 'cannot access destroy' do 
			delete :destroy, id: @user
			expect(response).to redirect_to('/sessions/new')
		end
	end
	describe 'when signed in as the wrong user' do 
		before do 
			@wrong_user = create_user 'julius', 'julius@lakers.com'
			session[:user_id] = @wrong_user.id
		end
		it 'cannot access profile page of another user' do 
			get :edit, id: @user 
			expect(response).to redirect_to("/users/#{@wrong_user.id}")
		end
		it 'cannot update another user' do 
			put :update, id: @user 
			expect(response).to redirect_to("/users/#{@wrong_user.id}")
		end
		it 'cannot destroy another user' do 
			delete :destroy, id: @user
			expect(response).to redirect_to("/users/#{@wrong_user.id}")
		end
	end
end

RSpec.feature 'signing up' do 
	scenario 'prompts for valid fields' do 
		visit '/users/new'
		expect(page).to have_field('email')
		expect(page).to have_field('name')
		expect(page).to have_field('password')
		expect(page).to have_field('password_confirmation')
	end
end


RSpec.feature 'creating a user' do 
	before do 
		visit '/users/new'
	end
	scenario 'creates a new user and redirects to profile page with proper credentials' do 
		fill_in 'email', with: 'kobe@lakers.com'
		fill_in 'name', with: 'Kobe'
		fill_in 'password', with: 'password'
		fill_in 'password_confirmation', with: 'password'
		find("input[value='Join']").click
		last_user = User.last
		expect(current_path).to eq("/users/#{last_user.id}")
	end
	scenario 'shows validation errors without proper credentials' do 
		find("input[value = 'Join']").click
		expect(current_path).to eq('/users/new')
		expect(page).to have_text('can\'t be blank')
		expect(page).to have_text('invalid')
	end
end


RSpec.feature 'user profile page' do 
	before do 
		@user = create_user
		log_in @user 
	end
	scenario 'displays information about the user' do 
		expect(page).to have_text("#{@user.name}")
		expect(page).to have_link('Edit Profile')
	end
end

RSpec.feature 'editing user' do 
	scenario 'displays prepopulated form' do 
		user = create_user
		log_in user 
		click_link('Edit Profile')
		expect(page).to have_field('email')
		expect(page).to have_field('name')
	end
end

RSpec.feature 'updating user' do 
	scenario 'updates user and redirects to profile page' do 
		user = create_user
		log_in user 
		expect(page).to have_text('kobe')
		click_link ('Edit Profile')
		fill_in 'name', with: 'drake'
		fill_in 'email', with: 'kobe@lakers.com'
		find("input[value='Update User']").click
		expect(page).not_to have_text('kobe')
		expect(page).to have_text('drake')
	end
end

RSpec.feature 'deleting account' do 
	scenario 'destroys user and redirects to login page' do 
		user = create_user
		log_in user
		click_link('Edit Profile')
		click_link('Delete Account')
		expect(current_path).to eq('/sessions/new')
	end
end

