class SharedFeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_condo, only: [:index, :show, :new, :create, :cancel]

  def index
    @shared_fees = SharedFee.where(condo_id: @condo.id).order(issue_date: :desc)
  end

  def show
    @shared_fee = SharedFee.find(params[:id])
  end

  def new
    @shared_fee = SharedFee.new
  end

  def create
    @condos = Condo.all
    @shared_fee = SharedFee.new(shared_fee_params)
    @shared_fee.condo_id = @condo.id
    if @shared_fee.save
      @shared_fee.calculate_fractions
      redirect_to condo_path(@condo.id), notice: I18n.t('success_notice_shared_fee')
    else
      flash.now[:alert] = I18n.t('fail_notice_shared_fee')
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    @shared_fee = SharedFee.find(params[:id])
    @shared_fee.canceled!
    redirect_to condo_shared_fees_path(@condo.id),
                notice: I18n.t('cancel_notice_shared_fee', shared_fee: @shared_fee.description)
  end

  private

  def find_condo
    @condo = Condo.find(params[:condo_id])
  end

  def shared_fee_params
    params.require(:shared_fee).permit(:description,
                                       :total_value,
                                       :issue_date)
  end
end
