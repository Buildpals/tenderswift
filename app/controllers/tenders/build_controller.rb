# frozen_string_literal: true

class Tenders::BuildController < ContractorsController
  include Wicked::Wizard

  before_action :set_policy

  steps :general_information,
        :tender_documents,
        :bill_of_quantities,
        :upload_documents

  def show
    @tender = Tender.find(params[:tender_id])
    authorize @tender
    render_wizard
  end

  def update
    @tender = Tender.find(params[:tender_id])
    authorize @tender

    if step == :bill_of_quantities
      save_tender
    elsif step == steps.last
      @tender.submitted_at = Time.current
      @tender.status = :active
      render_wizard @tender, notice: 'Your bid has been submitted successfully'
    else
      @tender.status = step.to_s
      @tender.update_attributes(tender_params)
      render_wizard
    end
  end

  def create
    @tender = current_quantity_surveyor.tenders.new
    authorize @tender
    @tender.setup_with_data

    redirect_to wizard_path(steps.first,
                            tender_id: @tender.id)
  end

  private

  def save_tender
    return if tender_params[:version_number] < @tender.version_number

    if @tender.update(tender_params)
      render json: @tender,
             only: %i[id version_number],
             status: :created
    else
      render json: @tender.errors, status: :unprocessable_entity
    end
  end

  def finish_wizard_path
    contractor_root_path
  end

  def set_policy
    Tender.define_singleton_method(:policy_class) do
      BuildTenderPolicy
    end
  end

  def tender_params
    params.require(:tender)
          .permit(:version_number, list_of_rates: {})
  end
end
