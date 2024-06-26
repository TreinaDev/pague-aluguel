class SharedFeesController < ApplicationController
  def show
    @shared_fee = SharedFee.find(params[:id])
    @condo = @shared_fee.condo
  end

  def new
    @condos = Condo.all
    @shared_fee = SharedFee.new
  end

  def create
    @shared_fee = SharedFee.new(shared_fee_params)
    if @shared_fee.valid?
      @shared_fee.save!
      redirect_to @shared_fee, notice: 'Conta Compartilhada lançada com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível lançar a conta compartilhada.'
      render 'new'
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
