class TenderTransactionMailer < ApplicationMailer


  helper ApplicationHelper

  default from: 'projects@buildpals.com'

  def confrim_purchase(participant)
    @participant = participant
    mail(to: @participant.email, subject: 'Successful purchase of tender documents')
  end

end
