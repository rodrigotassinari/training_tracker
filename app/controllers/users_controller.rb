class UsersController < ApplicationController

  skip_before_action :require_complete_user, only: [:edit, :update]

  # GET /user/edit
  # edit_user_path
  def edit
    current_user.locale = I18n.locale if current_user.locale.blank?
    current_user.time_zone = Time.zone.name if current_user.time_zone.blank?
  end

  # PUT /user
  # PATCH /user
  # user_path
  def update
    if current_user.update(user_params)
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
