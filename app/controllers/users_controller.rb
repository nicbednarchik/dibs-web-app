# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # Remove any custom attr_accessor / initialize – not needed in controllers

  # GET /users
  # Simple username search used by your header search bar
  def index
    @q = params[:q].to_s.strip
    @users =
      if @q.present?
        if ActiveRecord::Base.connection.adapter_name.downcase.start_with?("postgres")
          User.where("username ILIKE ?", "%#{@q}%").order(:username).limit(20)
        else
          User.where("LOWER(username) LIKE ?", "%#{@q.downcase}%").order(:username).limit(20)
        end
      else
        []
      end
  end

  # GET /users/:id
  # Show all of this user's posts, including dibbed ones (so gray overlay shows)
  def show
    @user = User.find(params[:id])
    @clothes = @user.clothes
                    .includes(:dibbed_by, photos_attachments: :blob)
                    .order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end
end
