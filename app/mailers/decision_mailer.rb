class DecisionMailer < ApplicationMailer

  default from: "projects@buildpals.com"

  def notify_disqualified(disqualified_contractor, request, body)
    @disqualified_contractor = disqualified_contractor
    @request_for_tender = request
    @message = body
    mail(to: @disqualified_contractor.email,
        subject: "#{@request_for_tender.quantity_surveyor.company_name} has come to a decison concerning #{@request_for_tender.project_name}"
    )
  end

  def award_contract(request, body)
    @request_for_tender = request
    @message= body
    mail(to: request.winner.email,
        subject: "#{@request_for_tender.quantity_surveyor.company_name} has come to a decision concerning #{@request_for_tender.project_name}"
    )
  end
end
