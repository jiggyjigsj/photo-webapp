class SessionsController < ApplicationController
  def view
    @view_page = true
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
     session[:user_id] = user.id
     flash[:success] = 'Successfully Logged In!'
     redirect_to '/'
    else
     flash[:warning] = 'Invalid Username or Password'
     redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully Logged Out!'
    redirect_to '/login'
  end
end
