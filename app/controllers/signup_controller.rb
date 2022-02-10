class SignupController < ApplicationController
  def view
    @view_page = true
  end

  def job
    user = User.new()
    user.username = params["username"]
    user.name = params["name"]
    user.password = params["password"]
    user.email = params["email"]
    user.phone = params["phone"]

    if user.save
      session[:user_id] = user.id
      flash[:success] = 'Successfully created user!'
      redirect_to '/login'
    else
      flash[:warning] = 'Invalid User or Password!'
      redirect_to '/signup'
    end
  end
end
