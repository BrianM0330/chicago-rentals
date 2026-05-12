class PinsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @pins = Pin.includes(:building, :locality).order(reported_on: :desc).limit(100)
  end

  def show
    @pin = Pin.includes(:building, :locality, :user, comments: :user, pin_flags: :user).find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
