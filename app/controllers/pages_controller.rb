class PagesController < ApplicationController

  skip_before_action :require_login, only: [:index]

  # GET /
  # root_path
  def index
  end

  # GET /private
  # private_path
  def private
    # FIXME temporary
  end

end
