class SharedFeesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @condo = Condo.find(params[:condo_id])
    @shared_fees = SharedFee.where(condo_id: @condo.id)
  end

  def show
    @shared_fee = SharedFee.find(params[:id])
    @condo = Condo.find(params[:condo_id])
  end

  def new
    @condos = Condo.all
    @shared_fee = SharedFee.new
    @selected_condo_id = params[:condo_id] || nil
  end

  def create
    @condos = Condo.all
    @shared_fee = SharedFee.new(shared_fee_params)
    if @shared_fee.save
      @shared_fee.calculate_fractions
      redirect_to @shared_fee, notice: I18n.t('success_notice_shared_fee')
    else
      flash.now[:alert] = I18n.t('fail_notice_shared_fee')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shared_fee_params
    params.require(:shared_fee).permit(:description,
                                       :total_value,
                                       :issue_date,
                                       :condo_id)
  end
end
