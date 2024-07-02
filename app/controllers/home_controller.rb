class HomeController < ApplicationController
  def index
    @admins = Admin.all
    @condos = Condo.all
  end
end
