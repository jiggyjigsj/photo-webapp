class IndexController < ApplicationController
  def view
    if current_user
      @name = current_user.name
      @email = current_user.email
      @phone = current_user.phone
    else
      flash[:warning] = "You must be logged in to see this page"
      redirect_to '/login'
    end
  end

  def job
    update_details = User.find(current_user.id)

    # update_details.username = params["username"]
    # update_details.name = params["name"]
    # update_details.password = params["password"]
    # update_details.email = params["email"]
    # update_details.phone = params["phone"]

    if update_details.update(:name => params["name"], :phone => params["phone"])
      flash[:success] = "Record updated successfully!"
    else
      flash[:warning] = "Record Failed to update"
    end
    redirect_to '/'
  end
end
