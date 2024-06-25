class BaseFeesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create]
  def new

  end

  def create

  end
end
