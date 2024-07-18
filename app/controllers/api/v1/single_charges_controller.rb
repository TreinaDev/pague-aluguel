class Api::V1::SingleChargesController < Api::V1::ApiController
  def create
    single_charge = SingleCharge.new(single_charge_params)

    return create_fine(single_charge) if single_charge.fine?
    return create_common_area_fee(single_charge) if single_charge.common_area_fee?

    render json: { message: 'Tipo de Cobrança inválido' }, status: :unprocessable_entity
  end

  private

  def create_common_area_fee(single_charge)
    if single_charge.save
      render json: {
        message: I18n.t('common-area-fee-charge-success'), single_charge_id: single_charge.id
        }, status: :created
    else
      render json: { message: single_charge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_fine(single_charge)
    if single_charge.save
      render json: { message: I18n.t('fine-charge-success') }, status: :created
    else
      render json: { message: single_charge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def single_charge_params
    params.require(:single_charge).permit(:description, :value_cents, :common_area_id, :unit_id, :charge_type,
                                          :issue_date, :condo_id)
  end
end
