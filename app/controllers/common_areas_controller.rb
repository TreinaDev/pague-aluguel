class CommonAreasController < ApplicationController
  before_action :authenticate_admin!

  def index
    @common_areas = CommonArea.all
  end
end
