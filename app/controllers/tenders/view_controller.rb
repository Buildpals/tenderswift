# frozen_string_literal: true

class Tenders::ViewController < ContractorsController
  include Wicked::Wizard

  before_action :set_tender

  before_action :set_policy

  steps :general_information,
        :tender_documents,
        :bill_of_quantities,
        :upload_documents,
        :results

  def show
    authorize @tender
    @submitted_tenders = @tender.request_for_tender
                                .tenders
                                .where.not(submitted_at: nil)

    if step.eql?(:results)
      unless @tender.request_for_tender.deadline_over?
        render 'no_results'
      else
        render_wizard
      end
    else
      render_wizard
    end
  end

  private

  def set_policy
    Tender.define_singleton_method(:policy_class) { ViewTenderPolicy }
  end

  def set_tender
    @tender = current_contractor.tenders.find(params[:tender_id])
  end
end
