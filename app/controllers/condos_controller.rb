class CondosController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @condos = Condo.all
  end
end
