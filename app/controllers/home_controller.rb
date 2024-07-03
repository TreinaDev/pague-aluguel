class HomeController < ApplicationController
  def index
    @recent_admins = Admin.last(3)
    @condos = Condo.all
  end
end