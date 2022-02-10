class ContactsController < ApplicationController
  def view
    if current_user
      @username = current_user.username
      @name = current_user.name
      @email = current_user.email
      @phone = current_user.phone
    else
      flash[:warning] = 'You must be logged in to see this page'
      redirect_to '/login'
    end
  end

  def job
    update_details = User.find(current_user.id)

    if update_details.update(:name => params["name"], :phone => params["phone"], :email => params["email"])
      flash[:success] = "Record updated successfully!"
    else
      flash[:warning] = "Record Failed to update"
    end
    redirect_to '/contacts'
  end
end
