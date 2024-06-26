class SharedFeesController < ApplicationController
  before_action :authenticate_admin!

  def show
    @shared_fee = SharedFee.find(params[:id])
    @condo = @shared_fee.condo
  end

  def new
    @condos = Condo.all
    @shared_fee = SharedFee.new
  end

  def create
    @condos = Condo.all
    @shared_fee = SharedFee.new(shared_fee_params)
    @units = @shared_fee.condo.units
    if @shared_fee.save
      @shared_fee.calculate_fractions
      redirect_to @shared_fee, notice: 'Conta Compartilhada lançada com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível lançar a conta compartilhada.'
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
