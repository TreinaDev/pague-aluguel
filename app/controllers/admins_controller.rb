class AdminsController < ApplicationController
  def index
    @admins = Admin.all
  end
end
