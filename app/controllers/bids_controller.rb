# frozen_string_literal: true

class BidsController < PublishersController
  before_action :set_tender

  before_action :set_policy

  def required_documents
    authorize @tender
  end

  def boq
    authorize @tender
  end

  def other_documents
    authorize @tender
  end

  def disqualify
    authorize @tender
    if @tender.update(disqualified: true)
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "#{@tender.contractors_company_name} " \
                    'has been disqualified'
    else
      redirect_back fallback_location: root_path,
                    notice: 'An error occurred while trying to disqualify ' \
                            "#{@tender.contractors_company_name}"
    end
  end

  def undo_disqualify
    authorize @tender
    if @tender.update(disqualified: false)
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "#{@tender.contractors_company_name} " \
                            'has been re-added to the shortlist'
    else
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: 'An error occurred while trying to re-add ' \
                            "#{@tender.contractors_company_name} to shortlist"
    end
  end

  def rate
    authorize @tender
    if @tender.update(rating: params[:rating])
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: 'The rating for ' \
                            "#{@tender.contractors_company_name} " \
                            'has been updated'
    else
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: 'An error occurred while trying to update the ' \
                            "rating for #{@tender.contractors_company_name}"
    end
  end

  private

  def set_policy
    Tender.define_singleton_method(:policy_class) { BidPolicy }
  end

  def set_tender
    @tender = Tender.find(params[:id])
  end
end
