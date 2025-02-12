class BountiesController < ApplicationController
  before_action :require_login

  def new
    @bounty = Bounty.new
  end

  def create
    @bounty = Bounty.new(bounty_params)
    @bounty.posted_by = current_user

    if @bounty.save
      redirect_to root_path, notice: "Bounty was successfully posted."
    else
      render :new
    end
  end

  private

  def bounty_params
    params.require(:bounty).permit(:title, :reward)
  end
end
