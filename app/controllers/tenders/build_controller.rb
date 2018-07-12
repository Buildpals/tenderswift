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

    if step == steps.last
      @tender.submitted_at = Time.current
      @tender.status = :active
      render_wizard @tender, notice: 'Your bid has been submitted successfully'
    else
      @tender.status = step.to_s
      @tender.update_attributes(request_params)
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

  def finish_wizard_path
    contractor_root_path
  end

  def set_policy
    Tender.define_singleton_method(:policy_class) do
      BuildTenderPolicy
    end
  end

  def request_params
    params.require(:tender)
          .permit(:publish,
                  list_of_rates: [
                    :updated_at,
                    rates: {}
                  ])
  end
end
