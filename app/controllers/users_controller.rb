class UsersController < ApplicationController

  def new
		@user = User.new
		@title = "Sign up"
  end

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			@title = "Sign up"
			# Exercise 8.6 #2
			# This resets the user entered password when they fail
			# validation during the signup process.  
			# Personally this behavior drives me bonkers on websites..
			# I can appreciate blanking them when they don't match
			# but when they do match and there is something else on the
			# form that is invalid I hate it.  Especially when the reason
			# the form won't validate is a bug.. and I am going bananas
			# re-entering the same information over and over again trying
			# to figure out what is wrong!
			@user.password = ''
			@user.password_confirmation = ''
			render 'new'
		end
	end
end
