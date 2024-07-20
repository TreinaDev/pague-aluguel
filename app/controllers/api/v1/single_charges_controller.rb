class Api::V1::SingleChargesController < Api::V1::ApiController
  def cancel
    single_charge = SingleCharge.find(params[:id])
    if check_charge_type(single_charge)
      return render json: { message: I18n.t('errors.invalid.charge') }, status: :unprocessable_entity
    end

    if single_charge.canceled!
      render json: { message: I18n.t('success.cancel.charge') }, status: :ok
    else
      render json: { message: single_charge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    single_charge = SingleCharge.new(single_charge_params)

    return create_fine(single_charge) if single_charge.fine?
    return create_common_area_fee(single_charge) if single_charge.common_area_fee?

    render json: { message: I18n.t('errors.invalid.charge') }, status: :unprocessable_entity
  end

  private

  def create_common_area_fee(single_charge)
    if single_charge.save
      render json: {
        message: I18n.t('success.create.common_area_charge'), single_charge_id: single_charge.id
      }, status: :created
    else
      render json: { message: single_charge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_fine(single_charge)
    if single_charge.save
      render json: { message: I18n.t('success.create.fine-charge') }, status: :created
    else
      render json: { message: single_charge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def check_charge_type(single_charge)
    single_charge.charge_type != 'common_area_fee'
  end

  def single_charge_params
    params.require(:single_charge).permit(:description, :value_cents, :common_area_id, :unit_id, :charge_type,
                                          :issue_date, :condo_id)
  end
end
