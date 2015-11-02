class UsersController < ApplicationController

  skip_before_action :require_complete_user, only: [:edit, :update]

  # GET /user/edit
  # edit_user_path
  def edit
  end

  # PUT /user
  # PATCH /user
  # user_path
  def update
    if current_user!.update(user_params)
      redirect_to root_path,
        notice: t('.success')
    else
      render :edit
    end
  end

  protected

  def user_params
    params.require(:user).
      permit(:name, :email, :locale, :time_zone)
  end

end
