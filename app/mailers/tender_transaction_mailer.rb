class TenderTransactionMailer < ApplicationMailer


  helper ApplicationHelper

  default from: 'projects@buildpals.com'

  def confirm_purchase(participant)
    @participant = participant
    mail(to: @participant.email, subject: 'Successful purchase of tender documents')
  end

end
