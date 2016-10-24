require 'rails_helper'

RSpec.describe LikesController, type: :controller do
#Likes Authentication
	before do 
		@user = create_user
		@secret = @user.secrets.create(content:'water')
		@like = Like.create(user_id: @user, secret: @secret)
	end
	describe 'when not logged in' do 
		before do 
			session[:user_id] = nil
		end
		it 'cannot access create' do 
			get :create
			expect(response).to redirect_to('/sessions/new')
		end
		it 'cannot access destroy' do 
			delete :destroy, id: @like 
			expect(response).to redirect_to('/sessions/new')
		end
	end
	#Like Authorization
	# describe 'when signd in as the wrong user' do 
	# 	before do 
	# 		@fake = create_user 'michael', 'michael@gmail.com'
	# 		session[:user_id] = @fake.id
	# 		@secret2 = @fake.secrets.create(content: 'bam!')
	# 		@like2 = Like.create(user_id: @user, secret: @secret2)
	# 	end
	# 	it 'cannot access destroy' do 
	# 		delete :destroy, id: @like2, user_id: @fake
	# 		expect(response).to redirect_to("/users/#{@fake.id}")
	# 	end
	# end
end

#DISPLAY LIKES
RSpec.feature 'displaying likes' do 
	before do 
		@user = create_user
		log_in @user 
		@secret = @user.secrets.create(content: 'oops')
		Like.create(user: @user, secret: @secret)
	end
	scenario 'displays amount of likes next to each secret' do 
		visit '/secrets'
		expect(page).to have_text(@secret.content)
		expect(page).to have_text('1 likes')
		visit "/users/#{@user.id}"
		expect(page).to have_text(@secret.content)
		expect(page).to have_text('1 likes')
	end
end

#CREATE LIKE
RSpec.feature 'creating likes' do 
	before do 
		@user = create_user
		log_in @user
		@user.secrets.create(content: 'oops')
	end
	scenario 'creates like and displays it both in profile and secrets pages' do 
		visit '/secrets'
		expect(page).to have_text('0 likes')
		find("input[value='Like']").click
		expect(current_path).to eq('/secrets')
		expect(page).to have_text('1 likes')
		visit "/users/#{@user.id}"
		expect(page).to have_text('1 likes')
	end
end

#UNLIKE
RSpec.feature 'destroying likes' do 
	before do 
		@user = create_user
		log_in @user 
		@secret1 = @user.secrets.create(content: 'blueberry')
		@secret2 = @user.secrets.create(content: 'banana')
		Like.create(user: @user, secret: @secret1)
	end
	scenario 'displays unlike button for secrets already liked' do 
		visit '/secrets'
		expect(page).to have_text(@secret1.content)
		expect(page).to have_text('1 likes')
		expect(page).to have_button('Unlike')
		expect(page).to have_text(@secret2.content)
		expect(page).to have_text('0 likes')
		expect(page).to have_button('Like')
	end
	scenario 'deletes like and displays the changes in both profile and secrets page' do
		visit '/secrets'
		click_button "Unlike"
		expect(current_path).to eq('/secrets')
		expect(page).not_to have_button('Unlike')
		expect(page).not_to have_text('1 likes')
		visit "/users/#{@user.id}"
		expect(page).not_to have_text('1 likes')
	end
	scenario 'creates like and displays it both in profile and secrets page' do 
		visit '/secrets'
		click_button 'Like'
		expect(current_path).to eq('/secrets')
		expect(page).not_to have_button('Like')
		expect(page).not_to have_text('0 likes')
		visit "/users/#{@user.id}"
		expect(page).not_to have_text('0 likes')	
	end
end

