class BillsController < ApplicationController
  before_action :set_condo
  before_action :set_bill, except: [:index]
  before_action :admin_authorized?
  before_action :bill_belongs_to_condo, only: [:show]

  def index
    @bills = Bill.where(condo_id: @condo.id)
  end

  def show
    set_unit
  end

  def accept_payment
    @bill.paid!
    redirect_to condo_bills_path(@condo.id), notice: I18n.t('success.payment.accepted')
  end

  def reject_payment
    @bill.pending!
    @bill.denied = true
    @bill.save
    @bill.receipt.destroy
    redirect_to condo_bills_path(@condo.id), notice: I18n.t('success.payment.rejected')
  end

  private

  def bill_belongs_to_condo
    return if @bill.condo_id.to_i == @condo.id.to_i

    redirect_to condo_bills_path(@condo.id), notice: I18n.t('errors.not_found.bills')
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_unit
    @unit = Unit.find(@bill.unit_id)
  end
end
