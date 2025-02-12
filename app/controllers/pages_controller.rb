class PagesController < ApplicationController
  before_action :require_login

  def dashboard
    @open_bounties = Bounty.where.not(posted_by: current_user)
  end
end
