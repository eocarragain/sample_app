class SessionsController < ApplicationController
  before_action :signed_in_user, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end


    # Before filters

    def signed_in_user
      if signed_in?
        redirect_to user_path(current_user), notice: "Already signed in as #{current_user.name}."
      end
    end
