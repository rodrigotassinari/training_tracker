class PagesController < ApplicationController

  skip_before_action :require_login, only: [:index]
  skip_before_action :require_complete_user, only: [:index]

  # GET /
  # root_path
  def index
  end

end
