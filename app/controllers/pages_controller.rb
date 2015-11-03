class PagesController < ApplicationController

  skip_before_action :require_login, only: [:index]
  skip_before_action :require_complete_user, only: [:index]

  # GET /
  # root_path
  def index
    redirect_to(workouts_path) if user_signed_in?

    page_meta.link :canonical, href: root_url

    # Meta tags for Facebook
    page_meta.tag :og, {
      # image: asset_url("logo_fb.png"), # TODO
      # image_type: "image/png",
      # image_width: 800,
      # image_height: 600,
      description: I18n.t('layouts.application.description'),
      title: 'Training Tracker',
      url: root_url
    }

    # Meta tags for Twitter
    page_meta.tag :twitter, {
      card: "summary_large_image",
      title: 'Training Tracker',
      description: I18n.t('layouts.application.description'),
      # site: "@trainingtracker",
      # creator: "@rtopitt",
      # image: asset_url("logo_tw.png"), # TODO
    }
  end

end
