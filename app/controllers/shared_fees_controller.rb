class SharedFeesController < ApplicationController
  def new
    @condos = Condo.all
    @shared_fee = SharedFee.new
  end
end
