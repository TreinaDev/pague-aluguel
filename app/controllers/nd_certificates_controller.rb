class NdCertificatesController < ApplicationController
  before_action :set_condo, only: [:index, :show]

  def certificate
    @nd_certificate = NdCertificate.find(params[:id])
  end

  def index
    @units = Unit.all(params[:condo_id])
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def create
    @unit = Unit.find(params[:unit_id])
    if all_bills_paid?
      if create_and_save_certificate
        redirect_to_success
      else
        redirect_to_error
      end
    else
      redirect_to_pending_debts
    end
  end

  private

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def all_bills_paid?
    @unit_bills = Bill.where(condo_id: @unit.condo_id, unit_id: @unit.id)
    @unit_bills.all? { |bill| bill.status == 'paid' }
  end

  def create_and_save_certificate
    @nd_certificate = NdCertificate.new(unit_id: @unit.id, issue_date: Time.zone.now)
    @nd_certificate.save
  end

  def redirect_to_success
    redirect_to certificate_condo_nd_certificate_path(condo_id: @unit.condo_id, id: @nd_certificate.id),
                notice: I18n.t('success_issued')
  end

  def redirect_to_error
    redirect_to condo_nd_certificates_path(@unit.condo_id), alert: I18n.t('fail_to_issue')
  end

  def redirect_to_pending_debts
    redirect_to condo_nd_certificates_path(@unit.condo_id), notice: I18n.t('pending_debt')
  end
end
