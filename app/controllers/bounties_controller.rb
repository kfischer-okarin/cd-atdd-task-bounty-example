class BountiesController < ApplicationController
  before_action :require_login

  def new
    @bounty = Bounty.new
  end

  def create
    @bounty = Bounty.new(bounty_params)
    @bounty.posted_by = current_user

    if current_user.balance < @bounty.reward
      flash.now[:alert] = "Cannot post bounty: insufficient balance"
      render :new, status: :unprocessable_entity
      return
    end

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
